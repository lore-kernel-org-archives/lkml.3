Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaISEWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:22:22 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47127 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaISEWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:22:21 -0400
Message-ID: <541BAF75.8050900@gmail.com>
Date: Fri, 19 Sep 2014 07:22:13 +0300
From: =?UTF-8?B?R2llZHJpdXMgU3RhdGtldmnEjWl1cw==?= 
	<giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Rene Kolarik <rene.kolarik@gmail.com>, gregkh@linuxfoundation.org,
        shawn.guo@freescale.com, kernel@pengutronix.de
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]imx-drm coding style fixes
References: <20140918225736.GA15881@rendy-i5>
In-Reply-To: <20140918225736.GA15881@rendy-i5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.09.19 01:57, Rene Kolarik wrote:
> Hello,
> 
> I've fixed coding style issues in drivers/staging/imx-drm directory. This is a part of Eudyptula Challenge.
Please submit your patches "inline" (look at /Documentation/SubmittingPatches section 7). Also, think about if it's worth seperating this patch into two or more since you are doing more than what you're saying in the description. 
Furthermore, your subject line is kind of wrong. Perhaps it should look something like this:
[PATCH] drivers: staging: imx-drm style cleanup (SubmittingPatches section 15)
Finally, you didn't mention what coding style issues you've fixed and these kind of patches are called clean-up patches.
> 
> Rene Kolarik
> 
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 

-- 
thanks,
Giedrius
