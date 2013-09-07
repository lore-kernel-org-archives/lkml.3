Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750913Ab3IGXDE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 19:03:04 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:54364 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3IGXDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 19:03:02 -0400
Date: Sun, 8 Sep 2013 02:02:52 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ADP1653 board code for Nokia RX-51
Message-ID: <20130907230252.GA10700@blackmetal.musicnaut.iki.fi>
References: <201302171616.50152@pali>
 <20130217190303.GC2317@blackmetal.musicnaut.iki.fi>
 <201303062112.06417@pali>
 <201309062234.05878@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309062234.05878@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 06, 2013 at 10:34:05PM +0200, Pali Rohár wrote:
> > --- /dev/null
> > +++ b/arch/arm/mach-omap2/board-rx51-camera.c
[...]
> Ping, can you review this patch v2?

I don't think Tony will accept any new board stuff for RX-51/N900.
See for example: http://marc.info/?l=linux-kernel&m=137629626213187&w=2

There should be initial Nokia N900 DTS file in 3.12-rc1, and we should
continue converting this board fully to DT.

A.
