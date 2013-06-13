Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863Ab3FMRqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:46:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59098 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758852Ab3FMRqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:46:50 -0400
Message-ID: <1371145608.31941.8.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
From: Joe Perches <joe@perches.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>
Date: Thu, 13 Jun 2013 10:46:48 -0700
In-Reply-To: <1552010.DOo3aEBKyJ@flatron>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
	 <9948950.GZ51yJYkxQ@flatron>
	 <CAD=FV=Un+Ti8atZLUbK+5w=dB7vX7HoxVacEGkjvCboVo4mNpA@mail.gmail.com>
	 <1552010.DOo3aEBKyJ@flatron>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 19:32 +0200, Tomasz Figa wrote:
[]
> Similarly for Kukjin, he's listed as the main Samsung maintainer already, 
> but AFAIK in this case the script can't infer this based on directory 
> structure. Let's see how it's done for other Samsung drivers:

A pattern could be added that matches any file with
"exynos" in it.

	N: Files and directories with regex patterns.
	   N:	[^a-z]tegra	all files whose path contains the word tegra
	   One pattern per line.  Multiple N: lines acceptable.

like:

N:	exynos
or
N:	drivers/pinctrl/.*exynos


