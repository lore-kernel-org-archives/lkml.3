Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3HFJj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:39:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52498 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452Ab3HFJj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:39:26 -0400
X-Sasl-enc: zBJQ5dHZ/L1ziCYBa262iwQrEdwROcCaXdI9GzoqOmiS 1375781961
Date: Tue, 6 Aug 2013 17:40:40 +0800
From: Greg KH <greg@kroah.com>
To: Andy Green <andy.green@linaro.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] warning-elimination: android: binder
Message-ID: <20130806094040.GD27889@kroah.com>
References: <CAAfg0W4jCXqfthyQi3X+hvznrnksDeJfSpKoymnc53fE=dRN9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfg0W4jCXqfthyQi3X+hvznrnksDeJfSpKoymnc53fE=dRN9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:36:19AM +0800, Andy Green wrote:
> From: Andy Green <andy.green@linaro.org>
> 
> warning-elimination: android: binder
> 
> This commit in mainline (now) causes a couple of warnings

What specifically are those warnings?  I don't see any here, so I'm
guessing your patch isn't really needed :)

(hint, hint, hint...)

greg k-h
