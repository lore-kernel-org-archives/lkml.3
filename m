Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967Ab3CUTFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:05:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3CUTFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:05:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 5/5] arm: dts: Convert mvebu device tree files to 64 bits
Date: Thu, 21 Mar 2013 19:03:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1363883179-1361-1-git-send-email-gregory.clement@free-electrons.com> <1363883179-1361-6-git-send-email-gregory.clement@free-electrons.com> <514B4A79.1070501@gmail.com>
In-Reply-To: <514B4A79.1070501@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303211903.52383.arnd@arndb.de>
X-Provags-ID: V02:K0:NSYDfrWU1THUkhLtY2GJlN641eBEIaA7uMixQDLyLDJ
 0jqk2GwNT4w2Yp3SsNzTGI7itYipCG7PoKuvE3bdRC/hSK9/z1
 K4zO/USToeyFsOk25qluQ1AP9Tfb6bHVCZocDnwP9Au24Ay9+z
 4nNv+JMdcwPHqWPqVnCWIKfXOWSwIuTj5zOkKB9esjdaZWDu+E
 4WHm32QAjJHRwQLUnvLPhNhp6ZLkVF8IhD25MYfV7e1G6JCSMd
 wJTUDPwdGBY1xcMPlxsZb2N3UP1hX9M7+zn9LQ64IYpMzOfxS0
 OTw5gV1uTLg4goj/Hrm0/8Z4DuruouwrwwcrBbPQK79O2Gej/X
 amUJBOK8n9UDeRuNc2eI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 March 2013, Rob Herring wrote:
> >       soc {
> > -             #address-cells = <1>;
> > -             #size-cells = <1>;
> > +             #address-cells = <2>;
> > +             #size-cells = <2>;
> 
> If all the addresses for the soc bus are below 4GB or even within a 4GB
> range if using the ranges property, then changing all this and
> everything below it is kind of pointless.

Good point. We'll probably also have to change it all again when we add a new
binding for that bus in 3.10, so it makes sense to change it only once.

	Arnd
