Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3AVND1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:03:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3AVND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:03:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 20/33] net: Convert to devm_ioremap_resource()
Date: Tue, 22 Jan 2013 13:03:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        w.sang@pengutronix.de, netdev@vger.kernel.org
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de> <20130121.152913.1377695352860141642.davem@davemloft.net> <20130122065629.GA14523@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130122065629.GA14523@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221303.06785.arnd@arndb.de>
X-Provags-ID: V02:K0:PwJuxv6YSE02pPLuXZW0rx0C86jUqN85KqSxHvbKAxP
 7mjytG418PPs8xG48S45BzEKbbWUVgn8+yswW8qHzmJvWM5FHi
 BDOc+fGCu1GVk5utBfMB3kxCC2+8QDNf8L7N5TCjbpCuiscxq6
 rqEQUW11OMnqCY/BzniitfoWSshcsn/xB0ks5l1L4Y2MFiqT1m
 7a2p1QhwpLAc89+xlaf/PIbkmBphfFqES7m9RCmuejK287x8ul
 9yoWOqfusQ937xlgoj8ziRaOQ/yzOV9K6CXx3nFc+bLfgq92qg
 H3D5EAUR5pD6u8gCCH7A/qKH72oKwD6t0tUkYMv1LHx5CdxQ/c
 oVAGr2zbwE3fCwig8Mqs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Thierry Reding wrote:
> I planned to do so initially, but that yielded a Cc list of 156 people
> and mailing lists, which I thought wasn't going to go down so well
> either. In general I like Cc'ing everyone concerned on all patches of
> the series, specifically for reasons of context. Some people have been
> annoyed when I did so. Still, for small series where only a few dozen
> people are concerned that seems to me to be the best way. But 156 email
> addresses is a different story.
> 
> Either you add to many people or you don't add enough. Where do we draw
> the line?

I've had the same problem a couple of times. The best compromise seems
to be to Cc only the top-level subsystem maintainers and mailing lists
on the first email.

	Arnd
