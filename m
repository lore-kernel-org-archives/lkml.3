Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3CLLTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:19:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62557 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3CLLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:19:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [RFC 17/17] unicore32: default GENERIC_GPIO to false
Date: Tue, 12 Mar 2013 11:18:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-kernel@vger.kernel.org
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com> <1363083150-30964-18-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1363083150-30964-18-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121118.55770.arnd@arndb.de>
X-Provags-ID: V02:K0:v4exc0Q3H5CSlFPsIYSHbGil/8eDijF4hywJUTKq5bu
 K6NsB2Z0/mOpPEZ4KSUbeLfn1vQNsgNFiBh/h3rZmzCV+v1Vru
 syzCn2QUf7NapoxCwJar56f/wlbBt8aoTn93szLa1InKZeB5AF
 0v+sIkJse78T3GX17aadkSTE7YXxI0xYi+IpKdduOakDjHPdqS
 vkSSf1wKgprEfX3T2Bx9nThS7KZpgr1nlKvSizEBIZqoorBao8
 yPstO77+UvDYa+w7gPFSLeDWQJBoDytfv3o4cGbaxKWY+T4PX4
 2l6DQ9wIPe5Vgr0eba7aXZf1PnKcDMjWAf9Vvc2D++xuiaHzm0
 sdYgq1gk0x9jPAP0zPiA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Alexandre Courbot wrote:
> @@ -24,7 +24,7 @@ config UNICORE32
>           Please see web page at <http://www.pkunity.com/>.
>  
>  config GENERIC_GPIO
> -       def_bool y
> +       def_bool n
>  

"def_bool n" is the same as "bool", but in general the latter syntax is preferred.

	Arnd
