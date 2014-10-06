Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaJFJ1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:27:05 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:51538 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaJFJ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:27:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
Date: Mon, 06 Oct 2014 11:26:50 +0200
Message-ID: <4788945.SoI4OqN9Zu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412586626.4054.42.camel@x220>
References: <1412586626.4054.42.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:bOT3ZurGOJmvI3UMUEo+9G5KMo8Ls+URmVqLwKzSo7s
 wRcgR9oO8mTpFeTdnVWsSjOqIy4NqF+zYjkf9kxBjXBh8RRrOK
 I3KhDUtYAc58gtko38BXQmpPGLXrQTlqwkuUPzr3A/exPsQvvS
 xTpa6STEMQNFWGeXc8dRq6enOXgLZDE52yWlmaGN+L9SXEWvej
 p29f+uHIMEqdwbf3MsF3mLZy8NNqWMsggywxK78PYbNKZIxdpT
 ALyAlknFf+2ZCgL2eHx99Gtg/HU5LDsBh/u9XoO6mgJSpc82l7
 R0HJuT2HzIWVUh/TqHUmiQkbONrNG9Mx4/DEwlk8DFYE3E48r1
 wQpJcekXOhBPizokxhG8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2014 11:10:26 Paul Bolle wrote:
>  config VIDEO_SAMSUNG_S5P_TV
>         bool "Samsung TV driver for S5P platform"
>         depends on PM_RUNTIME
> -       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
> +       depends on ARCH_EXYNOS || COMPILE_TEST
>         default n
>         ---help---
>           Say Y here to enable selecting the TV output devices for
> 

I wonder if it should now allow being built for ARCH_S5PV210.
Maybe it was a mistake to remove the PLAT_S5P symbol without changing
the use here?

Does S5PV210 have this device?

	Arnd
