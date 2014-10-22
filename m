Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaJVJbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:31:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44657 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaJVJbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:31:08 -0400
Date: Wed, 22 Oct 2014 11:30:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: Chen Yucong <slaoub@gmail.com>, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141022093042.GB2511@pd.tnic>
References: <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com>
 <20141008225750.GH16892@pd.tnic>
 <20141009165339.GA11360@arav-dinar>
 <20141009173529.GC17647@pd.tnic>
 <5436DB72.1090507@amd.com>
 <20141021202840.GD4420@pd.tnic>
 <1413942678.17435.11.camel@debian>
 <20141022081618.GA2511@pd.tnic>
 <1413968014.7070.12.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413968014.7070.12.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aravind,

question: what's the story with MC?_MISC[IntP], is that bit still there?
Because I don't see it in my BKDGs here.

The background of the story is

https://lkml.org/lkml/2014/10/7/84

There's this thing we did at the time

f227d4306cf3 ("x86, MCE, AMD: Make APIC LVT thresholding interrupt optional")

which, AFAICR, is about some F15h versions having a counter but *not*
generating a thresholding interrupt. Can you confirm that is still
the case and we can have a counter but no interrupt gets generated on
overflow?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
