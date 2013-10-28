Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3J1KpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:45:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49754 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab3J1KpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:45:01 -0400
Date: Mon, 28 Oct 2013 11:44:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andreas Werner <wernerandy@gmx.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: MM: Add PAT Type write-through in combination with
 mtrr
Message-ID: <20131028104458.GE4314@pd.tnic>
References: <1382878525-3410-1-git-send-email-wernerandy@gmx.de>
 <20131027133401.GB24817@pd.tnic>
 <20131027165159.GD1617@thinkpad.fritz.box>
 <20131027173131.GC21868@pd.tnic>
 <20131027175608.GA1340@thinkpad.fritz.box>
 <20131027190148.GD21868@pd.tnic>
 <20131028062946.GA1391@thinkpad.fritz.box>
 <20131028101749.GA4389@gmail.com>
 <20131028102938.GD4314@pd.tnic>
 <20131028103132.GA6274@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131028103132.GA6274@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:31:32AM +0100, Ingo Molnar wrote:
> The CLFLUSH is done afterwards (making it a use-once thing), so WB
> might still be faster and would avoid the PAT headache ...

Absolutely, that's why there's no need for a WT buffer at all, methinks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
