Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab3FJO6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:58:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49831 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FJO6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:58:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 4/6] ARM: sunxi: dt: Add Allwinner A10s DTSI
Date: Mon, 10 Jun 2013 16:58:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com> <3346364.JR9UrJYqP8@wuerfel> <20130610103435.GJ2748@lukather>
In-Reply-To: <20130610103435.GJ2748@lukather>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101658.28353.arnd@arndb.de>
X-Provags-ID: V02:K0:YBn9XvUxLDKnFM9kM9B2PhUZwDMaDqr58wtknpqO7G9
 gWRWoCYaIEzgoId3rEEDMHhe34bOk+fZo2N4M9e/Zl1AAdeT16
 /48JUHc04Jk0WgHRE6CeRS95ZuQqCg5GqFSoVYjK0jWeIbabKn
 QxCSlorkEyrGimjel97jirihQzV0upgTAXIWJSa0wOYd6GChE6
 DOtGVP97fLaXG7PgNQIJiLFSihqSi0ujxd1uLLiYRDJEffFQPj
 dbxc4tkOrL0mQ/ivPh06cs2LukReI7t63nxGg08GKMaQaC+eXs
 qQ3DxmzTmZmnsIeq550L2HVlwO2w0ru+sxPI63VG4mYxhyR4CG
 Rz0SAwRh3atWIfardfKc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013, Maxime Ripard wrote:
> I don't have the documentation at the moment, so I'm not exactly sure at
> which extent it's similar to the A13. Yet for the moment, the two dtsi
> are very different (different clock definitions, different muxings,
> etc.), so , I'm not quite sure about wether it would make stuff smaller.
> 
> Of course, if we find they actually share a lot, we can definitely make
> a common sun5i DTSI later.
> 
> But if you prefer to have it right now, I can always send a v2 :)

I thought it was actually the same silicon in a different package with
fewer pins, but if the files look very different right now, just leave
them separately.

	Arnd
