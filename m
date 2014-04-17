Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaDQQXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:23:00 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:43790 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265AbaDQQWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:22:43 -0400
Date: Thu, 17 Apr 2014 18:22:38 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: lee.jones@linaro.org, Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [rtc-linux] Re: [PATCH resend] mfd/rtc: s5m: Do not allocate
 RTC I2C dummy and regmap for unsupported chipsets
Message-ID: <20140417182238.7cfbf322@linux.lan.towertech.it>
In-Reply-To: <20140417080847.GF28725@lee--X1>
References: <1397461245-818-1-git-send-email-k.kozlowski@samsung.com>
	<20140417080847.GF28725@lee--X1>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 09:08:47 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> MFD changes look good to me. If Alessandro provides his Ack for the
> RTC adaptions I can setup an MFD-RTC branch for him to pull from in
> order to save conflicts at merge time.

 Hello,
   I do not keep an rtc git, so please add it to mfd
 or via another tree / next. The patch looks good to m.
 
 Acked-by: Alessandro Zummo <a.zummo@towertech.it>
  

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

