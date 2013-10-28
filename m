Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3J1Key (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:34:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56878 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab3J1Kex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:34:53 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20131028102938.GD4314@pd.tnic>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de> <20131027133401.GB24817@pd.tnic> <20131027165159.GD1617@thinkpad.fritz.box> <20131027173131.GC21868@pd.tnic> <20131027175608.GA1340@thinkpad.fritz.box> <20131027190148.GD21868@pd.tnic> <20131028062946.GA1391@thinkpad.fritz.box> <20131028101749.GA4389@gmail.com> <20131028102938.GD4314@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with mtrr
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 28 Oct 2013 03:31:58 -0700
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
CC: Andreas Werner <wernerandy@gmx.de>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Message-ID: <9f8cb8da-e453-464a-8c95-9d06b58ad613@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort of; the writes combine in the cache.

Borislav Petkov <bp@alien8.de> wrote:
>On Mon, Oct 28, 2013 at 11:17:49AM +0100, Ingo Molnar wrote:
>> And regular write-back cacheable isn't sufficient because the CPU
>> could do things like prefetch your range automatically?
>
>Yeah, he's doing a CLFLUSH anyway which basically makes it a
>write-through...

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
