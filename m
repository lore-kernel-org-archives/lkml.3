Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaIEM3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:29:36 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59107 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaIEM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:29:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH 11/19] ARM: S5PV210: Remove support for board files
Date: Fri, 05 Sep 2014 14:28:45 +0200
Message-ID: <16177201.Mk3a7oJAud@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409918658.7832.25.camel@x220>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com> <201409041802.36466.arnd@arndb.de> <1409918658.7832.25.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y0x6e0pnXodjuuHGJNp/YiieXsumsn1gIAQ5fiIrbOn
 GSbf+v9TTbaaXLrQWVnYfSIPEQqhLK8vrmUG2NHXGQeuPMiggm
 6vzLlWl80nce05lw0r2phoei/aDoR/7OdX2PoLr7zGwtult4h5
 Y3tEogU5L1Kr963gZaDI3O5deNVfVTaB/XciVBh2XbshG67GHW
 CZlHYXBT878HE1KI/ZkrzuzYwvGlMlWBM0RmmXAmG9KscQCFvC
 5yFYEA7F6kpzclO/wpVFu+3EKmo+gSVrBe3Q0GbuBt2F0wvgpW
 lxXYCo8e/2KE4tTXOBj1NwDYbZRUA+7UXBKbDbbbRJ1xHSRirs
 RG7UZW2Ex2RDu/Doj5ng=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 14:04:18 Paul Bolle wrote:
> 
> On Thu, 2014-09-04 at 18:02 +0200, Arnd Bergmann wrote:
> > I think it would be nice if you could submit a patch to remove the
> > drivers from ASoC, then we can see if anybody complains.
> 
> Just to know what I'm getting my self into: whom would you expect to
> send me agitated messages once those patches have landed?

That would be somebody who is using their own patches on top of
mainline and didn't notice that upstream broke under them ;-)

	Arnd
