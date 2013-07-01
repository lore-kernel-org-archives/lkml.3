Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab3GAWUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:20:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3GAWUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:20:06 -0400
Date: Mon, 1 Jul 2013 15:20:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: inkern: fix iio_convert_raw_to_processed_unlocked
Message-Id: <20130701152004.cfddc36e7b3d9d63e1960514@linux-foundation.org>
In-Reply-To: <1372696809-14661-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1372696809-14661-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Jul 2013 18:40:09 +0200 Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> When reading IIO_CHAN_INFO_OFFSET, the return value of iio_channel_read() for
> success will be IIO_VAL*, checking for 0 is not correct.

I have a canned response:

When writing a changelog, please describe the end-user-visible effects
of the bug, so that others can more easily decide which kernel
version(s) should be fixed, and so that downstream kernel maintainers
can more easily work out whether this patch will fix a problem which
they or their customers are observing.

> Cc: <stable@vger.kernel.org> # 3.10.x

Especially when cc'ing -stable.


