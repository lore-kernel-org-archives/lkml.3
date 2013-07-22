Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3GVXBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:01:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46741 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3GVXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:01:11 -0400
Message-ID: <51EDB9B3.4010909@linaro.org>
Date: Mon, 22 Jul 2013 16:01:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile
References: <1361563736-28241-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1361563736-28241-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 12:08 PM, Prarit Bhargava wrote:
> If I explicitly disable the clocksource watchdog in the x86 Kconfig,
> the x86 kernel will not compile unless this is properly defined.

Going through my backlog, I noticed I never picked this up. Queued for 3.12.

thanks
-john

