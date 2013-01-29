Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3A2CFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:05:38 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35447 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3A2CFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:05:34 -0500
Date: Tue, 29 Jan 2013 03:05:32 +0100
From: Andreas Mohr <andi@lisas.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        rjw@sisk.pl, lenb@kernel.org
Subject: Re: [RFC PATCH 1/3] PM: Introduce suspend state PM_SUSPEND_FREEZE
Message-ID: <20130129020532.GA22941@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359300060-2967-1-git-send-email-rui.zhang@intel.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

first, thanks a lot for advancing PM infrastructure!

>  #define PM_SUSPEND_ON		((__force suspend_state_t) 0)
> -#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 1)
> +#define PM_SUSPEND_FREEZE	((__force suspend_state_t) 1)
> +#define PM_SUSPEND_STANDBY	((__force suspend_state_t) 2)
>  #define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
> +#define PM_SUSPEND_MIN		PM_SUSPEND_FREEZE
>  #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)

I'll just pretend to be hopeful that you managed to hunt down all
relevant code sites (possibly even splattered around drivers?)
which may have made illegally hard-coded assumptions
about the number of PM_SUSPEND state "enum"s ;)
(e.g. comparisons - such as "==", "<=" etc. - come into mind)


Review of your patch was all fine, nothing to object about.

Thanks,

Andreas Mohr
