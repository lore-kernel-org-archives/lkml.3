Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3CKIDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 04:03:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3CKIDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 04:03:08 -0400
Date: Mon, 11 Mar 2013 09:03:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Silviu Popescu <silviupopescu1990@gmail.com>
cc: linux-media@vger.kernel.org, mchehab@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] soc_camera: convert to devm_ioremap_resource()
In-Reply-To: <CAPWTe+LMw1r9N7ObARu5Fs3OUS99ATjtjARAPbUK+4CmpcG4eQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1303110902320.21241@axis700.grange>
References: <1362987621-6527-1-git-send-email-silviupopescu1990@gmail.com>
 <Pine.LNX.4.64.1303110849530.21241@axis700.grange>
 <CAPWTe+LMw1r9N7ObARu5Fs3OUS99ATjtjARAPbUK+4CmpcG4eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:NqiTxrxaxN1/2IoQ9kqjAl4orieIzyosUGkLPNLbf4M
 kQ1kAI/+Uhk5Qre4qYKN5EYtmYmbLxDkpWsRT7ME3azUYlu0Yg
 5qCMhjByeE2/3HDi1B+5K/EjSrmxCvgKVNtXYTs79VCU2RuNA4
 Q72p/kXbid9wzD6DxuksOO2f+P374Z0QPJgc65DmigAjl2rCBc
 zPaltDynOZNrxHJNG7OLIeVnI1moyc5Dr2FFKoUuCqCPMpUba+
 h6QOMRKUbXIeNntFztXMzUJsn4PfydUgr3WH5dsd/D50VqoXpq
 muKJSx4TK7YucxiHdRxafLucgPoUuT4WRoRp36W/y9ADdkliei
 zN0SZmtXIqP2W3pMQePSVoe3QcB6x8M3zUuE42kAzD3okFFSJY
 P3OpN6LHZZRaQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013, Silviu Popescu wrote:

> On Mon, Mar 11, 2013 at 9:50 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> >
> > Is there anything in this patch, that this patch series
> >
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/61337
> >
> > is missing?
> >
> > Thanks
> > Guennadi
> 
> Hello Guennadi,
> 
> I seem to have missed that patch series. And no, this does not cover
> anything extra.

Good, thanks for checking!

> I'm sorry for the lack of attention on my behalf.

No problem, it's hard to follow all incoming changes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
