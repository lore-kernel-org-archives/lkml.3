Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaHMOWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:22:12 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35813 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaHMOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:22:10 -0400
Date: Wed, 13 Aug 2014 15:22:07 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/5] efi: add kernel param efi=noruntime
Message-ID: <20140813142207.GR15082@console-pimps.org>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-2-git-send-email-dyoung@redhat.com>
 <20140813081347.GA3977@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813081347.GA3977@darkstar.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug, at 04:13:47PM, Dave Young wrote:
> 
> For sharing functions I moved old_map here, but rethinking about it maybe
> it's better to keep it in arch code.
> 
> Matt, I see you have some code for libstub option parsing, I will rebase
> on your efi/next and I'm thinking to add a generic function for parsing
> params like below (for old_map, but libstub can not use it):
 
Makes sense to me.

-- 
Matt Fleming, Intel Open Source Technology Center
