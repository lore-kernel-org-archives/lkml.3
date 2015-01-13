Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbbAMQTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:19:10 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:59711 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbbAMQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:19:06 -0500
Date: Tue, 13 Jan 2015 17:19:04 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <xlpang@126.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: Re: [RFC PATCH v2 3/9] rtc/test: Update driver to address
 y2038/y2106 issues
Message-ID: <20150113171904.6b2327d5@linux.lan.towertech.it>
In-Reply-To: <1421163897-8020-4-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-4-git-send-email-xlpang@126.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 23:44:51 +0800
Xunlei Pang <xlpang@126.com> wrote:

> This patch resolves them by:
> - Repalce get_seconds() with get_seconds64()
> - Replace rtc_time_to_tm() with rtc_time64_to_tm()
> - Change test_rtc_set_mmss() to use rtc_class_ops's set_mmss64()

 so we no more have a non time64 test driver?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

