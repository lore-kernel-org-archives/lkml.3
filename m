Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaI3MPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:15:40 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57614 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaI3MPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:15:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>
Subject: Re: [PATCH] spi: bcm53xx: add BCMA dependency
Date: Tue, 30 Sep 2014 14:15:33 +0200
Message-ID: <3210109.EFf2P6X6HM@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACna6ryoq0A_6745aemJPQTEZxncmDRkCOPB3ZUHtNhXqXf2Fw@mail.gmail.com>
References: <3256402.M8e92DFkbg@wuerfel> <CACna6ryoq0A_6745aemJPQTEZxncmDRkCOPB3ZUHtNhXqXf2Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:u0f6hBfPEoarlTOFOPIRXU0itiQCtbKIYRoj4K4yZYE
 GGsM+YZO5aU0vUbvuZwARj3P1pLjswSy+zyfbj/FVD2Xou6e1S
 +WJJxFRZ1YkQKaw9KFvbQUQTeGjiPS3IgnyTNuds326vr32BoY
 SHMpDz01721HgyXC3uRz2LqIHys+YK4PfDD+uEQQ6yFPMVi/IQ
 pm7/bPKjcL1sH4HTk4adEwQEsW5AWQ15l9OJtV5JeONkdJgITk
 0nwLsmQKU6U1IatiqGa/pdBAWTS7aDngJ0Mejxb6N0tjvdAYCo
 HmH5P81JO48fX4Zg/OxyhAtL0VjUM3aP5YxaMxaW0Zd54sfQev
 Y6189FLNBNnHDjsxlLtc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 14:13:35 Rafał Miłecki wrote:
> On 30 September 2014 14:09, Arnd Bergmann <arnd@arndb.de> wrote:
> > The BCMA bus framework can be disabled on bcm53xx, which leads to a link
> > error when building the SPI driver:
> 
> You missed this one:
> https://git.kernel.org/cgit/linux/kernel/git/broonie/spi.git/commit/?h=for-next&id=933fc7b06ca62741fd5067edab13068d13b3cb35
> 

Right, I'm still catching up with last week's build regressions.

	Arnd
