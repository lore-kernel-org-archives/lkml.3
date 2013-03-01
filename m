Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3CAGUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:20:01 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60639 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAGT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:19:59 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFx2Cuuq2YW6mexxZ88TNm=FLYUYPzeLqN=y46oYxZJ3wQ@mail.gmail.com>
References: <1362092093-4839-1-git-send-email-olof@lixom.net>
	<CA+55aFx2Cuuq2YW6mexxZ88TNm=FLYUYPzeLqN=y46oYxZJ3wQ@mail.gmail.com>
Date: Thu, 28 Feb 2013 22:19:58 -0800
Message-ID: <CAOesGMiMWaEmPMJ2q2t9gsTa2gFZm_iwc6v9wO7htyPrOKNx=Q@mail.gmail.com>
Subject: Re: [GIT PULL 0/3] arm-soc: late changes for 3.9
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ARM SoC <arm@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 8:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

>> I've pushed a resolved branch for reference (late-branches-resolved)
>> in case you want to compare conflict resolutions.
>
> So Arnd's tag talked about removing the stale gpio.h, but I think it
> was the i2c.h that was now also stale. So I removed both - even though
> technically, the merge should have left i2c.h since it was in both
> parents. You should double-check that, but I don't see how that
> <linux/i2c.h> could *possibly* be valid any more, and people had tried
> (unsuccessfully) to remove it once already, so...

The i2c include is definitely unnecessary since there's no
i2c_board_info stuff left in the file. Thanks for catching that.


-Olof
