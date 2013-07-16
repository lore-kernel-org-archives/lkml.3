Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab3GPCjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:39:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47961 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab3GPCja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:39:30 -0400
Message-ID: <51E4B250.8000204@zytor.com>
Date: Mon, 15 Jul 2013 19:39:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] logo: Remove trailing whitespace from logo_linux_clut224.ppm
References: <1373876954-30437-1-git-send-email-geert@linux-m68k.org> <CA+55aFxGymOvvaYfOg22AdHpxEOuOctfC8vRW+_u=vtua8Dksg@mail.gmail.com>
In-Reply-To: <CA+55aFxGymOvvaYfOg22AdHpxEOuOctfC8vRW+_u=vtua8Dksg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 06:02 PM, Linus Torvalds wrote:
> 
> That said, even if it wasn't temporary, I think we might be better off
> with the raw format that the netpbm tools generate these days.
>

For "these days" meaning "since the 1980s".  I would suggest bumping up
to the 1990s and go with PNG.

	-hpa


