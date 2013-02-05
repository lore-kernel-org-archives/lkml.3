Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3BEOu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:50:56 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63908 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab3BEOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <1359720305-31933-5-git-send-email-blogic@openwrt.org>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<1359720305-31933-5-git-send-email-blogic@openwrt.org>
Date: Tue, 5 Feb 2013 15:50:46 +0100
Message-ID: <CACRpkdaaV6RVrQ8s0S3Y8jXUVNya33X-nT_XAX4JX9o55E7jxg@mail.gmail.com>
Subject: Re: [PATCH 05/11] PINCTRL: lantiq: the pinconf OD parameter argument
 was ignored
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 1:04 PM, John Crispin <blogic@openwrt.org> wrote:

> When setting the OpenDrain bit we should really honour the argument passed
> inside the devicetree.
>
> Signed-off-by: John Crispin <blogic@openwrt.org>

I have applied this to the fixes on top of patch 1/11 and 2/11.

I hope that is what you want, you realize that I cannot send all of
these patches to the -rc series, new stuff goes into devel for-next.

This one seemed to depend on the other fixes as well...

Please verify that this is OK for you, i.e. that you
don't have regressions when 1,2,5 are applied by themselves.

Yours,
Linus Walleij
