Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3C0SLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:11:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58940 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3C0SLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:11:36 -0400
Date: Wed, 27 Mar 2013 14:11:26 -0400 (EDT)
Message-Id: <20130327.141126.2163700256471831702.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, mcarlson@broadcom.com, mchan@broadcom.com,
        netdev@vger.kernel.org, oded@privatecore.com, spender@grsecurity.net,
        benli@broadcom.com
Subject: Re: [PATCH] tg3: fix length overflow in VPD firmware parsing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130327164050.GA26838@www.outflux.net>
References: <20130327164050.GA26838@www.outflux.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 27 Mar 2013 11:11:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Wed, 27 Mar 2013 09:40:50 -0700

> Commit 184b89044fb6e2a74611dafa69b1dce0d98612c6 ("tg3: Use VPD fw version
> when present") introduced VPD parsing that contained a potential length
> overflow.
> 
> Limit the hardware's reported firmware string length (max 255 bytes) to
> stay inside the driver's firmware string length (32 bytes). On overflow,
> truncate the formatted firmware string instead of potentially overwriting
> portions of the tg3 struct.
> 
> http://cansecwest.com/slides/2013/PrivateCore%20CSW%202013.pdf
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reported-by: Oded Horovitz <oded@privatecore.com>
> Reported-by: Brad Spengler <spender@grsecurity.net>

Applied.
