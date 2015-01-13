Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbbAMQR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:17:59 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:59704 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbbAMQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:17:58 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 11:17:57 EST
Date: Tue, 13 Jan 2015 17:12:46 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <xlpang@126.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: Re: [RFC PATCH v2 1/9] rtc: Provide y2038 safe
 rtc_class_ops.set_mmss() replacement
Message-ID: <20150113171246.76931f81@linux.lan.towertech.it>
In-Reply-To: <1421163897-8020-2-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-2-git-send-email-xlpang@126.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 23:44:49 +0800
Xunlei Pang <xlpang@126.com> wrote:

> +	else if (rtc->ops->set_mmss64) {
> +		 ;
> +
> +		secs64 = rtc_tm_to_time64(tm);

 time64_t secs64 = rtc_tm_to_time64(tm);

 would do as well. add spaces, variables
 and empty lines only when required for readability.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

