Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3IPSam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:30:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48005 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3IPSal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:30:41 -0400
Message-ID: <52374E4E.4060401@linaro.org>
Date: Mon, 16 Sep 2013 11:30:38 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: elad.wexler@gmail.com
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Time: Clocksource: fix 'ret' data type of sysfs_override_clocksource()
 and sysfs_unbind_clocksource()
References: <1378981734-15613-1-git-send-email-elad.wexler@gmail.com>
In-Reply-To: <1378981734-15613-1-git-send-email-elad.wexler@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 03:28 AM, elad.wexler@gmail.com wrote:
> From: Elad Wexler <elad.wexler@gmail.com>
>
> sysfs_override_clocksource(): The expression 'if (ret >= 0)' is always true.
> This will cause clocksource_select() to always run.
> Thus modified ret to be of type ssize_t.
>
> sysfs_unbind_clocksource(): The expression 'if (ret < 0)' is always false.
> So in case sysfs_get_uname() failed, the expression won't take an effect.
> Thus modified ret to be of type ssize_t.
>
> Signed-off-by: Elad Wexler <elad.wexler@gmail.com>

Queued for 3.13.

thanks
-john

