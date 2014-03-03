Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaCCOIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:08:37 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:37716 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980AbaCCOIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:08:36 -0500
Date: Mon, 3 Mar 2014 14:08:11 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 06/22] Add helper functions used by arm/arm64
Message-ID: <20140303140811.GA18828@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
 <1391619853-10601-7-git-send-email-leif.lindholm@linaro.org>
 <20140213112606.GF20717@console-pimps.org>
 <CAFECyb_wUphr4XOyW9tC-Rw5Py3m39e6GQorCtFGtSXTUTBnFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb_wUphr4XOyW9tC-Rw5Py3m39e6GQorCtFGtSXTUTBnFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb, at 11:02:49AM, Roy Franz wrote:
> 
> The get_dram_base() function is only used by arm/arm64, but
> there is nothing architecture specific about it, which is why I put it
> here to begin with.  I don't feel strongly about this either way.

Sorry Roy, I just realised that you probably wanted a response from me
about this last point.

OK, leaving get_dram_base() in efi-stub-helper.c is fine.

FYI, "NUL" isn't a typo,

> -	options_size++;  /* NUL termination */
[...]
> +	options_size++;  /* NULL termination */

http://en.wikipedia.org/wiki/Null_character

-- 
Matt Fleming, Intel Open Source Technology Center
