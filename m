Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbAMQW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:22:58 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:59749 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbbAMQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:22:57 -0500
Date: Tue, 13 Jan 2015 17:17:44 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <xlpang@126.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: Re: [RFC PATCH v2 2/9] time: Provide y2106 safe get_seconds()
 replacement
Message-ID: <20150113171744.69254bfd@linux.lan.towertech.it>
In-Reply-To: <1421163897-8020-3-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-3-git-send-email-xlpang@126.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 23:44:50 +0800
Xunlei Pang <xlpang@126.com> wrote:

> -EXPORT_SYMBOL(get_seconds);
> +EXPORT_SYMBOL(get_seconds64);

 Please leave get_seconds untouched

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

