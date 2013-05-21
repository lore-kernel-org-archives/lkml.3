Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3EUG06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:26:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41158 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab3EUG05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:26:57 -0400
Date: Mon, 20 May 2013 23:26:52 -0700
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] pinctrl: samsung: fix suspend/resume functionality
Message-ID: <20130521062652.GE19627@quad.lixom.net>
References: <1368746388-20194-1-git-send-email-dianders@chromium.org>
 <1368765198-25550-1-git-send-email-dianders@chromium.org>
 <CACRpkdZ1zBrp+jpgw8o_PVd_bcQMpkFXvRAwfJH6KCztT4jx+w@mail.gmail.com>
 <CAD=FV=XOiVdkEhYu+u-aGkD0DpxWn369uD_r4Pmw=7gHKLjOuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XOiVdkEhYu+u-aGkD0DpxWn369uD_r4Pmw=7gHKLjOuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 07:59:27AM -0700, Doug Anderson wrote:
> Linus,
> 
> On Mon, May 20, 2013 at 4:47 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > Looks good to me.
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > How are you going to merge this?
> >
> > Samsung tree?
> >
> > My pinctrl development tree?
> >
> > Or my fixes tree, if it's a regression for v3.10?
> 
> It is a regression for v3.10 so it would be nice to get it in there
> (Tomasz's patches, too).
> 
> It looks like the majority of recent commits to this file went through
> your tree and that seems fine to me unless anyone else on this thread
> has objections.

Sounds good to me.


-Olof
