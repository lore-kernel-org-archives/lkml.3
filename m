Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaCGJdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:33:15 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41948 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbaCGJdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:33:13 -0500
Date: Fri, 7 Mar 2014 10:33:10 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: Re: [PATCH V1 2/2] rtc: da9063: RTC driver
Message-ID: <20140307103310.3444cef6@linux.lan.towertech.it>
In-Reply-To: <93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
References: <cover.1394124002.git.stwiss.opensource@diasemi.com>
	<93327cde91bcaef9a467adc6c7b34c3231d9e1e7.1394124002.git.stwiss.opensource@diasemi.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 16:40:02 +0000
"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:

> Change History:
> 
> Changes made to this driver since previous RFC V1
> Comments by Alessandro Zummo
> - http://www.kernelhub.org/?p=2&msg=426327
> - Use return PTR_ERR(rtc->rtc_dev); instead of goto err; return err.
> - Request the interrupt before the RTC device is registered with the
>   call to devm_rtc_device_register.


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

