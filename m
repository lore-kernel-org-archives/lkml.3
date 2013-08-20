Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab3HTL4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:56:53 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:33228 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3HTL4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:56:52 -0400
Date: Tue, 20 Aug 2013 12:56:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: mfd: as3722: introducing ams AS3722 PMIC driver
Message-ID: <20130820115646.GJ23699@lee--X1>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Florian Lobmaier wrote:
> Thank you for the response regarding the correct formatting of the patches. I will try to fulfill the requirements as expected. Now tried to introduce the as3722 mfd driver in logical steps. Please keep in mind that the driver is already fully written, so the bit-by-bit introduction within the files would be a really hard requirement to fulfill.

So this is still not split up in the way that we'd normally
expect. You're still splitting up the patches per *file*, when in
actual fact, they should be split up by *functionality*. I think this
is the third time I've mentioned this.

I've also said something similar here, which might be easier to
understand:
  http://www.spinics.net/lists/netdev/msg246457.html

You need to learn how to use `git add -i` if you're going to get this
right (the other way is to copy and paste pieces of code into a file
before saving and committing, but I suggest you master the former
suggestion). You need to be adding to the patches a hunk at a time, or
even smaller using `git add`s 'edit' capability.

> One question I have still in mind: How do I reply correctly to already sent mails? Which command is recommended in this case?

To reply to emails on the list, you just need to use your standard
email client in the normal way.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
