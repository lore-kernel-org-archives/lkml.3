Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaA2Mpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:45:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64151 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaA2Mpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:45:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iop32x: gpio breakage after "instantiate GPIO from platform device"
Date: Wed, 29 Jan 2014 13:45:40 +0100
Message-ID: <4529033.RhLP7Lt6Fg@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACRpkdbd1FOOZOrF5crh3dYfYOy1CaYFH-SOqw_SJmd39JBjhg@mail.gmail.com>
References: <4202760.m9CxkiIWk3@wuerfel> <CACRpkdbd1FOOZOrF5crh3dYfYOy1CaYFH-SOqw_SJmd39JBjhg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dnfg6JHa8bkv64Nj2ktEOi+yWGu8+Y9ijEestwmMeha
 O7tKr8Se4FLfAPBGMOcn80rFXsD5fTIC5rDmBvAOpQCCAVHhH3
 i0ytjMYl6TyrUqZxrZTxmlo4NCPi/U3WdplXFpJIoysdNcjMhD
 fNCjhxy+fU3neXKHonvGErZPAwStAnIspsoz4tks+llZYeZKHA
 x4l+CZ6JGRWTgto/6PIJqiUXQ0dyH0JhGWdGyCETohbylqGWWZ
 /w8tseyTRS00smPpaxAJ9OJPGUE9GB4nQxwMcfH1WX8cqcb0QT
 PaNTZiDTAA8ucYAdcW38M5eDzPQGiKaxJlMqVHfTqwVlTZuwaN
 YGFlzGJ0y42KHssm/RLY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 January 2014 13:41:59 Linus Walleij wrote:
> On Tue, Jan 28, 2014 at 10:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > Commit 7b85b867b9904 "ARM: plat-iop: instantiate GPIO from platform
> > device" nicely cleaned up the gpio register access for iop, but
> > forgot one board that directly pokes into the gpio registers
> > to do a system reset.
> >
> > That board no longer compiles, and this patch just disables
> > the code in question to work around it so I can locally build
> > randconfig again, but it needs to be fixed properly.
> 
> OK I'm sending a proper fix instead.

Ok, thanks!

	Arnd
