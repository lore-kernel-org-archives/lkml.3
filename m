Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3LXCMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:12:06 -0500
Received: from prifuk.spider.cz ([31.31.77.241]:56949 "EHLO prifuk.cz"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab3LXCMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:12:03 -0500
From: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, elias.vds@gmail.com
Subject: Re: [RFC  v3] Add ff-memless-next
Date: Tue, 24 Dec 2013 03:11:57 +0100
Message-ID: <16141479.Xuvegy6qFd@geidi-prime>
User-Agent: KMail/4.12 (Linux/3.13.0-1-ARCHMOD; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1387844508.22671.73.camel@joe-AO722>
References: <1494187.y8mYFDm1lA@geidi-prime> <1387844508.22671.73.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 of December 2013 16:21:48 you wrote:
> On Mon, 2013-12-23 at 23:46 +0100, Michal Malý wrote:
> > One case where uncombinable effects were mishandled was corrected. Rest of
> > the changes are just coding style fixes.
> 
> trivia:
> > diff --git a/drivers/input/ff-memless-next.c
> > b/drivers/input/ff-memless-next.c
> []
> 
> > +static __always_inline s32 mlnx_calculate_x_force(const s32 level,
> > +						  const u16 direction)
> 
> __always_inline is almost never warranted.
> gcc generally does the right thing.
I did some reading about __always_inline vs. plain inline and I ran into
some contradictory information about what is considered broken. Thanks
for letting me know...

Is there anything else that needs some reviewing?
