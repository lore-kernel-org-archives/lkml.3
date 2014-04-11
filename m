Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaDKH0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:26:44 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:50704 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaDKH0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:26:42 -0400
Message-ID: <1397201173.4420.0.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCHv3 0/5] net: rfkill: gpio: cleanup and a few new acpi ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
        Marc Dietrich <marvin24@gmx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Date: Fri, 11 Apr 2014 09:26:13 +0200
In-Reply-To: <5345680F.3040903@wwwdotorg.org>
References: <1396360976-28657-1-git-send-email-heikki.krogerus@linux.intel.com>
	 <1396946275.5936.2.camel@jlt4.sipsolutions.net>
	 <20140409100147.GB3083@xps8300> <5345680F.3040903@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 09:32 -0600, Stephen Warren wrote:

> > Stephen! Are you expecting any changes to board-paz00.c in this kernel
> > cycle? If not, I think it would be easiest if Johannes, you take the
> > whole set. What do you guys think?
> 
> I can't predict the future, but the chances are pretty slim - that file
> is pretty tiny and doesn't have much churn.
> 
> The best approach is to put this series in its own topic branch. Then,
> if any conflict does come up, I can simply merge the branch into the
> Tegra treee and apply the conflicting patches on top.

Ok, I'll do that. Shout now if you don't want these patches merged :)

johannes

