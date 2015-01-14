Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbbANPjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:39:09 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:37759 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbbANPjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:39:08 -0500
Date: Wed, 14 Jan 2015 16:39:05 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Xunlei Pang <xlpang@126.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH v2 3/9] rtc/test: Update driver to address
 y2038/y2106 issues
Message-ID: <20150114163905.1c0cf7d1@linux.lan.towertech.it>
In-Reply-To: <CADcy93Vo6BoU6noPHXRCy7nYtW3q9DUZFXO4v9LE+iMn=Kk4cw@mail.gmail.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
	<1421163897-8020-4-git-send-email-xlpang@126.com>
	<20150113171904.6b2327d5@linux.lan.towertech.it>
	<CADcy93WPZCmPLUsa9kmz6GtD7E3+8td1PJteJxnZi0R2mLAYKw@mail.gmail.com>
	<20150114160308.08a7f45b@linux.lan.towertech.it>
	<CADcy93Vo6BoU6noPHXRCy7nYtW3q9DUZFXO4v9LE+iMn=Kk4cw@mail.gmail.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 23:26:37 +0800
Xunlei Pang <pang.xunlei@linaro.org> wrote:

> But on the other hand, we will have no test for  set_mmss64(),
> because adding the set_mmss64() will make set_mmss() dysfunctional.

 add a module parameter

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

