Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaDHN0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:26:12 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39486 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbaDHN0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:26:09 -0400
Date: Tue, 8 Apr 2014 16:25:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roger <rogerable@realtek.com>
Cc: Lee Jones <lee.jones@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 3/3] memstick: Add realtek USB memstick host driver
Message-ID: <20140408132527.GB4912@mwanda>
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>
 <1395744293-24398-4-git-send-email-rogerable@realtek.com>
 <533A3080.2020008@realtek.com>
 <20140401150654.fe27636428a62fdf9e0d2dc1@linux-foundation.org>
 <20140402151654.GA24060@lee--X1>
 <5343ADFA.7010703@realtek.com>
 <20140408113751.GG8888@lee--X1>
 <5343F535.5070408@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5343F535.5070408@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:10:13PM +0800, Roger wrote:
> On 04/08/2014 07:37 PM, Lee Jones wrote:
> >>>
> >>Lee,
> >>
> >>When I prepare my next submission, I found a previous version of
> >>this patch set(and only the 1/3 'mfd' part)  seems to be merged in
> >>the following commit:
> >>
> >>commit e5744abb2fa3629aa5a94e21ca1eae32ff2fe00b
> >>Merge: c29aa15 2d28ca7
> >>Author: Linus Torvalds <torvalds@linux-foundation.org>
> >>Date:   Mon Apr 7 10:24:18 2014 -0700
> >>
> >>     Merge tag 'mfd-for-linus-3.15' of
> >>git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
> >>
> >>Is there any chance to revert it? Or what can I do to help current
> >>situation?
> >
> >What will happen if we don't revert it? Does it depend on something
> >else?
> >
> No, it has no dependency error but only provides an unused mfd
> device and exports nothing functional to user.
> 
> I think it would be good to submit the diff between the merged 1/3
> patch and the v6, along with full 2/3 and 3/3.

Yes.  That sounds best.

regards,
dan carpenter

