Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388Ab3D3LkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:40:08 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:18518 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab3D3LkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:40:05 -0400
Date: Tue, 30 Apr 2013 13:40:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: balbi@ti.com, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: Kconfig "softdepends" idea
Message-ID: <20130430114004.GA15804@merkur.ravnborg.org>
References: <517F9472.2030106@ti.com> <20130430102440.GA15522@merkur.ravnborg.org> <20130430103318.GB12161@arwen.pp.htv.fi> <517FA68B.20001@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517FA68B.20001@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> SHOW_ALL_DRIVERS" is not very descriptive. I'm not sure if that matters,
> though. One doesn't need to read the Kconfig files every day =).
> 
> But presuming most of the drivers would use that, it would add quite a
> bit of repetition to the Kconfig files. Well, ok, I have no idea how
> many drivers have dependencies that could be removed.
> 
> So SHOW_ALL_DRIVERS sounds quite an easy solution to this.

Someone suggested to add symbols that are only set yo "y" for allyesconfig or allmodconfig.
This would be what you actuayl require here as what you are after is better
build coverage.

But we should not annouyt the user just to get better build coverage - which
is why hiding irrelevant symbols is good.

	Sam
