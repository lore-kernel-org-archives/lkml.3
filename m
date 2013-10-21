Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3JUMRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:17:03 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:36949 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab3JUMRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:17:00 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2013 08:17:00 EDT
Date: Mon, 21 Oct 2013 08:06:34 -0400
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
To: "hyunhee.kim" <hyunhee.kim@samsung.com>
Cc: dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        peter.ujfalusi@ti.com, wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] Input: add regulator haptic driver
Message-ID: <20131021120634.GA24439@jake.ruivo.org>
References: <000a01cec629$3cf34de0$b6d9e9a0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01cec629$3cf34de0$b6d9e9a0$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hyunhee,
On Fri, Oct 11, 2013 at 11:26:05AM +0900, hyunhee.kim wrote:
> +static void regulator_haptic_work(struct work_struct *work)
> +{
> +	struct regulator_haptic *haptic = container_of(work,
> +						       struct
> regulator_haptic,

you got a line wrap damage patch

-- 
Aristeu

