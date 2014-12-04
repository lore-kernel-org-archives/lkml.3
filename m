Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaLDKGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:06:12 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:34363 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbaLDKFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:05:54 -0500
Date: Thu, 4 Dec 2014 11:05:51 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Sanchayan Maity <maitysanchayan@gmail.com>
Cc: rtc-linux@googlegroups.com, stefan@agner.ch, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RESEND PATCHv2] drivers/rtc/rtc-snvs: Add clock support
Message-ID: <20141204110551.0837304e@linux.lan.towertech.it>
In-Reply-To: <bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
References: <cover.1417585458.git.maitysanchayan@gmail.com>
	<bf8571fc7474877be39a5a4e9d4705358e63d840.1417585458.git.maitysanchayan@gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Dec 2014 11:28:55 +0530
Sanchayan Maity <maitysanchayan@gmail.com> wrote:

> The clock is not strictly enforced, as this would
> break the i.MX devices. The clocking for the i.MX
> devices seems to be enabled elsewhere and enabling
> RTC SNVS for Vybrid results in a crash. This patch
> adds the clock support but also makes it optional
> so Vybrid platform can use the clock if defined
> while making sure not to break i.MX .
> 
> Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

