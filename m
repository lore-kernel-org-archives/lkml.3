Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3H1XDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:03:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35053 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab3H1XDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:03:49 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: rockchip: Implement .request() and .free() callbacks on the GPIO chips
Date: Thu, 29 Aug 2013 01:03:44 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1377613817.14731.1.camel@phoenix> <CACRpkdbJMG-MbBrt19kj_NTrarhcHfDCppciuL93fT95Mby7MA@mail.gmail.com>
In-Reply-To: <CACRpkdbJMG-MbBrt19kj_NTrarhcHfDCppciuL93fT95Mby7MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308290103.45003.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 28. August 2013, 13:25:57 schrieb Linus Walleij:
> On Tue, Aug 27, 2013 at 4:30 PM, Axel Lin <axel.lin@ingics.com> wrote:
> > Implement .request() and .free() callbacks on the GPIO chips to inform
> > pinctrl when a GPIO is requested or freed.
> > 
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> 
> Ohhh that will have semantic effects so really need to wait
> for Heiko's opinion on this one.

I don't see any showstoppers here. Tested it on my machine with gpio-keys 
without any issues popping up. So

Tested-by: Heiko Stuebner <heiko@sntech.de>
Acked-by: Heiko Stuebner <heiko@sntech.de>


Heiko
