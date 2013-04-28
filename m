Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3D1BGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:06:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3D1BGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:06:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: Re: [PATCH 6/8] kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
Date: Sun, 28 Apr 2013 03:05:57 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Greg KH <greg@kroah.com>
References: <cover.1366841993.git.yann.morin.1998@free.fr> <201304272301.00587.arnd@arndb.de> <20130427223158.GA24099@free.fr>
In-Reply-To: <20130427223158.GA24099@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304280305.57219.arnd@arndb.de>
X-Provags-ID: V02:K0:ovyYViWLgWHV9HcEI4AK8vYCHj9nXOyewyAh0UpZVQX
 56UOQ3tu3/ExTTkvCUjyHiXjO0Q87LV1tVY54FDpoYrMvAbKpq
 E04idOqI47aozneLnGcwaaNLZ/oaJ/5N19dgwZ/XmMRRDK8VaX
 WHTQb2pHMMj4zBRku8Cv83TB26lZSGu3jyH48X/4yG9EFHR7pd
 K2asXwhtgIKAyoQcWOA95bEw62OGJ/VZjt0MQ7Fg4h0p2Y9rIp
 UMyvaEkugA7knXEkQ+y7yQbL6/+kKgA91Ac9nJitxYWBhG+fFR
 XY3qfOaMc3DYQ5YXgirNoyTZnpQKwOScCkB1n8e2vKmniIxGbR
 BuOO3aRXs88CO5F9ksBc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 April 2013, Yann E. MORIN wrote:
> Fact is, choices are properly randomised, unless KCONFIG_ALLCONFIG is
> passed.
> 
> So, if you currently rely on choices not being randomised, it means
> you're using KCONFIG_ALLCONFIG [*] so you can set CONFIG_ARCH_MULTIPLATFORM
> in the defconfig you use.

Yes, you are right, I can easily do this.

	Arnd
