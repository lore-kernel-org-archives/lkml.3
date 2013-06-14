Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3FNRXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:23:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41584 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FNRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:23:47 -0400
Message-ID: <51BB51A0.6050408@linaro.org>
Date: Fri, 14 Jun 2013 10:23:44 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 7/9] RFC: rtc: implement rtc_read_timeval()
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-8-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-8-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> Some RTCs offer a higher resolution than seconds. To support reading such
> high resolution timestamps from inside the kernel implement
> rtc_read_timeval() and add a read_timeval to the rtc-ops.

So I like the direction this patch is going. But if we're going to add a 
new interface, lets not use an already out-dated structure (timeval).

Instead could you rework this to be timepsec based? Or ktime_t if its 
really internal only?

thanks
-john

