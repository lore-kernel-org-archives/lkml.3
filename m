Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaGQKe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:34:27 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56089 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712AbaGQKeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:34:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Date: Thu, 17 Jul 2014 12:33:32 +0200
Message-ID: <6350114.L77bTv76Ul@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140717095657.GC17877@ulmo>
References: <201407130545.23004.marex@denx.de> <6823014.2plXDE9VA9@wuerfel> <20140717095657.GC17877@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AWoig9/F19CkpprDn+B2UT04DGwJ1CIoPDF+FCwKe2T
 RIJUnK4mNoOJ589ubhs5HZfOS5LYY0lmpLOoP2Tay3P9BoPiCo
 v6Y0nJomQn2O5SuOK11daUYv2l1YU7l5GoOlm/X1twfalCGXMu
 sKpGtAffz4wivuLJ+WvMJeK8stOUwKu4gdlk+SiJeCjzxTtmDN
 8zrupqw4+x8e0NsT/6O+eHyoBOdmEsP4NBBQOvPpJTRZqDCV8r
 K5H6/VPjk05tqMCFC0DxaIOmrvhGqDffVHhwOhrzBejn/Jf2R4
 QA7wcCtbHAcYfNNEAw+FSArewCMJuczdI+1Y2dQw5JoGLEqRjQ
 3O+fFNY34NbDem6SSkkQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 11:56:58 Thierry Reding wrote:
> On Thu, Jul 17, 2014 at 11:20:36AM +0200, Arnd Bergmann wrote:
> [...]
> >                       score should set HAS_IOMEM and doesn't
> > even have public compilers
> 
> This begs an interesting question. Should it be made a requirement to
> have publicly available compilers for new architectures so that they can
> at least be compile-tested? Preferably this would of course be in source
> form so that there aren't any dependencies on the distribution.

The question has come up a few times. I wouldn't mandate that the port
has an upstream gcc (you've got to start mainlining one of them first
after all), but having compilers available for download should probably be
required. It's hard to ask for a particular quality of that gcc port
though, or to expect it to stay available online.

Where did you find the gcc port for score?

	Arnd
