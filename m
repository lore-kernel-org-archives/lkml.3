Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab3EQNbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:31:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab3EQNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:31:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/4] ARM: Remove boilerplate debug_ll_io_init code
Date: Fri, 17 May 2013 15:31:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com> <201305160040.54399.arnd@arndb.de> <5194F944.2040803@free-electrons.com>
In-Reply-To: <5194F944.2040803@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305171531.16240.arnd@arndb.de>
X-Provags-ID: V02:K0:1kyGBEJT78y8+ks41GqaRj+lGdAtyePFwwC3L8wVtuq
 wYv3cHDyCk51N/P7VXzRXhZemKdLpsITAPjhpSrWbt49xufn84
 Dx64oMhjKgEBZw/5fzqGgp8nOXT1IpFQFZEz3NAy2GUpTF+mID
 va3judKj1AN20DyOitDQRI1gTavOo/q/DETded08kffElz6FRo
 VOnWguv9u+2cXBhmyBpZogUUoGHC0mhu81FKIwoUwubUUSk9f1
 UB/yVpQ4w/XpmNe3xTxAAR9U0/okjFw8PqlTgYU8aSU41kpH0R
 tu2mhn+0QhWLJnBmWnhpAUzA37xmLp67e1OJCUphNIl+FTs9Xx
 YdV4QPR+YU0nipDPehl4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 May 2013, Maxime Ripard wrote:

> 
> How will we merge this? The first patch would be merged by Russel and
> the 3 others by their respective maintainers?

I think since it's mostly platform code and all trivial, we can merge
it into the next/cleanup branch in arm-soc directly.

	Arnd
