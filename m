Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbbAMQUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:20:40 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:59727 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbbAMQUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:20:37 -0500
Date: Tue, 13 Jan 2015 17:20:34 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <xlpang@126.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Xunlei Pang <pang.xunlei@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [RFC PATCH v2 4/9] rtc/ab3100: Update driver to address
 y2038/y2106 issues
Message-ID: <20150113172034.04e781ce@linux.lan.towertech.it>
In-Reply-To: <1421163897-8020-5-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-5-git-send-email-xlpang@126.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 23:44:52 +0800
Xunlei Pang <xlpang@126.com> wrote:

> From: Xunlei Pang <pang.xunlei@linaro.org>
> 
> This driver has a number of y2038/y2106 issues.

 This should probably be evaluated by
 Linus Walleij <linus.walleij@stericsson.com>



-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

