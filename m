Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965547Ab3GCTnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:43:06 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35593 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab3GCTnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:43:04 -0400
Message-ID: <51D47EC3.5080305@kernel.org>
Date: Wed, 03 Jul 2013 20:42:59 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, stable@vger.kernel.org
Subject: Re: [PATCH] iio: inkern: fix iio_convert_raw_to_processed_unlocked
References: <1372696809-14661-1-git-send-email-alexandre.belloni@free-electrons.com> <20130701152004.cfddc36e7b3d9d63e1960514@linux-foundation.org>
In-Reply-To: <20130701152004.cfddc36e7b3d9d63e1960514@linux-foundation.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 11:20 PM, Andrew Morton wrote:
> On Mon,  1 Jul 2013 18:40:09 +0200 Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> 
>> When reading IIO_CHAN_INFO_OFFSET, the return value of iio_channel_read() for
>> success will be IIO_VAL*, checking for 0 is not correct.
> 
> I have a canned response:
> 
> When writing a changelog, please describe the end-user-visible effects
> of the bug, so that others can more easily decide which kernel
> version(s) should be fixed, and so that downstream kernel maintainers
> can more easily work out whether this patch will fix a problem which
> they or their customers are observing.
> 
>> Cc: <stable@vger.kernel.org> # 3.10.x
> 
> Especially when cc'ing -stable.
> 
As Andrew suggested I have added a few more details and applied the patch
to the fixes-togreg branch of iio.git.

Thanks,

Jonathan
