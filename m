Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaJVIQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:16:47 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52933 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbaJVIQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:16:44 -0400
Date: Wed, 22 Oct 2014 10:16:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141022081618.GA2511@pd.tnic>
References: <1412138102.21488.20.camel@debian>
 <20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com>
 <20141008225750.GH16892@pd.tnic>
 <20141009165339.GA11360@arav-dinar>
 <20141009173529.GC17647@pd.tnic>
 <5436DB72.1090507@amd.com>
 <20141021202840.GD4420@pd.tnic>
 <1413942678.17435.11.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413942678.17435.11.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:51:18AM +0800, Chen Yucong wrote:
> Can you check the following link? The link contains my reply about
> "x86, MCE, AMD: Move invariant code out from loop body". The reply was
> sent to you on October 7, but until now, there aren't any comments
> from you!

https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/commit/?h=ras-for-3.19&id=69b957583580bf40624553c64d802fefb54199cb

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
