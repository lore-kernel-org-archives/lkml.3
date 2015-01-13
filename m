Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbbAMQXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:23:35 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:59762 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753404AbbAMQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:23:34 -0500
Date: Tue, 13 Jan 2015 17:23:32 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <xlpang@126.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: Re: [RFC PATCH v2 6/9] rtc/mxc: Modify rtc_update_alarm() not to
 touch the alarm time
Message-ID: <20150113172332.1851a210@linux.lan.towertech.it>
In-Reply-To: <1421163897-8020-7-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-7-git-send-email-xlpang@126.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 23:44:54 +0800
Xunlei Pang <xlpang@126.com> wrote:

> rtc_class_ops's set_alarm() shouldn't deal with the alarm date,
> as this is handled in the rtc core.

 Please CC the author and ask him. The same applies for the other drivers.
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

