Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbaHFLH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:07:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40627 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbaHFLHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:07:55 -0400
Date: Wed, 6 Aug 2014 13:07:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, jan.kiszka@siemens.com,
        mingo@kernel.org, huawei.libin@huawei.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Message-ID: <20140806110748.GC27033@pd.tnic>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
 <20140804102301.GB4808@pd.tnic>
 <53E04457.2060507@intel.com>
 <20140805075419.GA18234@pd.tnic>
 <53E0A3EE.50708@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53E0A3EE.50708@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 05:29:18PM +0800, Lan Tianyu wrote:
> I think you can pull Tod's tool from git hub and do test from your
> laptop. I attached a configure file come from ubuntu which is easier
> to produce the issue. You can use it to reproduce the issue.

Right, so I ran it on an old dualcore AMD laptop I have lying around
here and it didn't show any difference with or without your patch.

For all 4 runs I did with the tool running it without any arguments (so
it did the default thing), I got suspend time for CPU1 of 4-6 msec and
resume of ~20msec.

I don't know whether it is the dual core or AMD but your patch doesn't
change anything on that laptop which is ok, I'd guess.

> Ok. BTW, I have tested it on the Ivbridge and Haswell machines.

Yeah, add those numbers to the commit message too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
