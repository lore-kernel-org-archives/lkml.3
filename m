Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbaI1Qlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:41:50 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44145 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaI1Qls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:41:48 -0400
Date: Sun, 28 Sep 2014 17:41:46 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Mark Salter <msalter@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>, Russ Anderson <rja@sgi.com>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 7/7] efi_rtc: probe function error out in case no efi
 runtime enabled
Message-ID: <20140928164146.GA18635@console-pimps.org>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007953-15151-1-git-send-email-dyoung@redhat.com>
 <1411403609.25340.55.camel@deneb.redhat.com>
 <20140923072426.GB3916@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923072426.GB3916@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep, at 03:24:26PM, Dave Young wrote:
> 
> If that's the case then this patch should be unnecessary, I have no
> machine to test it currently though.

Thanks, I've dropped this from the v3.18 queue.

-- 
Matt Fleming, Intel Open Source Technology Center
