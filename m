Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3APIuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:50:37 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53247 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3APIug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:50:36 -0500
Date: Wed, 16 Jan 2013 08:50:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 00/18] AB8500 battery management series upgrade
Message-ID: <20130116085030.GG9379@gmail.com>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
 <20130116014812.GA27065@lizard.fhda.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130116014812.GA27065@lizard.fhda.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013, Anton Vorontsov wrote:

> On Fri, Jan 11, 2013 at 01:12:48PM +0000, Lee Jones wrote:
> > Here we go again. This patches include your suggested fixups.
> > 
> > Please find the next instalment of the AB8500 Power drivers upgrade.
> > A lot of work has taken place on the internal development track, but
> > little effort has gone into mainlining it. At last count there were
> > around 70+ patches which are in need of forward-porting, then
> > upstreaming. This patch-set aims to make a good start. :)
> 
> All except 14/18 applied, thanks!
> 
> Some general notes:
> 
> - No need for the power: prefix in the subject, unless it is a core
>   change;
> - Try be consistent on the capitalization (I tend to capitalize the first
>   word, "driver: Fix something". But it's up to you, just be consistent).
> - Try keep the patches compilable. :)
> - ..and applicable to the battery tree.
> 
> Thanks!
> 
> Anton
> 
> p.s. I'll push out the battery tree a bit later (in a couple of hours), so
> don't worry if the commits won't appear just now.

I'll keep 14/18 back until the next push and I'll try to be
diligent in adhering to your requests.

Very nice. Thanks Anton.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
