Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbaDHOnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:43:11 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:47964 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301AbaDHOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:43:06 -0400
Date: Tue, 8 Apr 2014 16:43:02 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: Ales Novak <alnovak@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] RTC: Fix infinite loop in initializing the alarm.
Message-ID: <20140408164302.0f7c51b7@linux.lan.towertech.it>
In-Reply-To: <1396911282-4410-1-git-send-email-alnovak@suse.cz>
References: <1396911282-4410-1-git-send-email-alnovak@suse.cz>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Apr 2014 00:54:42 +0200
Ales Novak <alnovak@suse.cz> wrote:

> In __rtc_read_alarm(), if the alarm time retrieved by
> rtc_read_alarm_internal() from the device contains invalid values
> (e.g. month=2,mday=31) and the year not set (=-1), the initialization
> will loop infinitely because the year-fixing loop expects the
> time being invalid due to leap year.
> 
> Fix reduces the loop to the leap years and adds final validity check.
> 
> Signed-off-by: Ales Novak <alnovak@suse.cz>

 Seems reasonable.

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

