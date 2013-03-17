Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3CQQRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 12:17:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45912 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3CQQRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 12:17:23 -0400
Date: Sun, 17 Mar 2013 12:17:21 -0400 (EDT)
Message-Id: <20130317.121721.1666807600727125521.davem@davemloft.net>
To: linus.walleij@linaro.org
Cc: erwan.yvin@stericsson.com, linux-kernel@vger.kernel.org,
        sjur.brendeland@stericsson.com
Subject: Re: [PATCH] caif: remove caif_shm
From: David Miller <davem@davemloft.net>
In-Reply-To: <CACRpkdbj7uHwMSTgUzapRQUTJQaPB+c0A1t2DcAuQi7Tf9K2Pg@mail.gmail.com>
References: <1362736584-21115-1-git-send-email-erwan.yvin@stericsson.com>
	<CACRpkdbj7uHwMSTgUzapRQUTJQaPB+c0A1t2DcAuQi7Tf9K2Pg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 17 Mar 2013 09:17:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 14 Mar 2013 14:25:23 +0100

> On Fri, Mar 8, 2013 at 10:56 AM, Erwan Yvin <erwan.yvin@stericsson.com> wrote:
> 
>> caif_shm is an old implementation
>> caif_shm will be replaced by caif_virtio
>>
>> Signed-off-by: Erwan Yvin <erwan.yvin@stericsson.com>
>> Acked-by: Sjur Brendeland <sjur.brandeland@stericsson.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> The story is something like this: U5500 used this, but was cancelled
> and the silicon did not reach anyone outside ST-Ericsson.
> 
> Then for the next platforms, we have gone for the leaner & cleaner
> approach of using virtio, rpmesg and rproc.
> 
> This can be safely deleted.

That's a better explanation, applied to net-next, thanks!
