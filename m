Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaFBRmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:42:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:59639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaFBRmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:42:53 -0400
Message-ID: <538CB805.8030303@kernel.org>
Date: Mon, 02 Jun 2014 18:44:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Federico Di Pierro <nierro92@gmail.com>, gregkh@linuxfoundation.org,
        jg1.han@samsung.com, sachin.kamat@linaro.org
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix some coding style problem in drivers/staging/iio/frequency/ad9832.c
References: <538CAEBD.5040501@gmail.com>
In-Reply-To: <538CAEBD.5040501@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/14 18:05, Federico Di Pierro wrote:
> Hi!
> This is my latest task of the eudyptula challenge.
> Just a very small patch! It fixes 3 little coding style problems.
> I'm using linux-next.
Fair enough, but you need to spend a little time working
on the 'how' of your patch submission.
See Documentation/SubmittingPatches and repost the patch according
to those guidelines.

Also at a quick glance, unless I am very bored I'm unlikely to take
such a minor white space and bracket adjustment patch. If it were
part of a bigger series doing something more interesting I'd be
more interested.

If you want to approach this driver, then feel free but there are
many more major issues within it to be looked at such as ABI
compliance.  See Documentation/ABI/testing/sysfs-bus-iio and friends
and compare the driver with them.  Off the top of my head I can't
remember how bad this driver is but I doubt everything is well
documented.

Don't feel disheartened, as I would be happy to see more substantial
cleanup patches from you as part of the challenge or otherwise.

Good luck,

Jonathan
