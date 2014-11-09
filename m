Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKIDuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 22:50:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60431 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaKIDuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 22:50:22 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 8 Nov 2014 19:50:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Oded Gabbay <oded.gabbay@amd.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        David Rientjes <rientjes@google.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sebastian Reichel <sre@debian.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH v5 06/24] Update MAINTAINERS and CREDITS files with
 amdkfd info
Message-ID: <20141109035006.GE1026@thin>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
 <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
 <20141108190125.GA2131@thin>
 <1415479769.23530.31.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415479769.23530.31.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 12:49:29PM -0800, Joe Perches wrote:
> On Sat, 2014-11-08 at 11:01 -0800, Josh Triplett wrote:
> > On Sat, Nov 08, 2014 at 08:37:27PM +0200, Oded Gabbay wrote:
> > >  CREDITS     |  7 +++++++
> > >  MAINTAINERS | 10 ++++++++++
> > >  2 files changed, 17 insertions(+)
> > 
> > Given the wide variety of folks who patch CREDITS and MAINTAINERS, might
> > I suggest adding CREDITS and MAINTAINERS themselves to the MAINTAINERS
> > file (perhaps in the same entry as get_maintainer.pl), so that
> > get_maintainer.pl does not fall back to git history for them?
> 
> Thanks but:
> 
> There is no MAINTAINERS/CREDITS maintainer.
> 
> I'm not volunteering.

Oh, I thought from all your work on file patterns and other such
improvements that you were the de-facto MAINTAINERS maintainer.

> Maybe you?

No thank you.

> But maybe something like this would help:
> 
> It has to have both an M: and an S: entry
> with maintained or supported to stop get_maintainers
> from doing a git history lookup.
> 
> ---
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0662378..584fd69 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5881,6 +5881,12 @@ F:	drivers/mailbox/
>  F:	include/linux/mailbox_client.h
>  F:	include/linux/mailbox_controller.h
>  
> +MAINTAINERS/CREDITS
> +M:	linux-kernel@vger.kernel.org
> +S:	Maintained
> +F:	MAINTAINERS
> +F:	CREDITS

Sending something only to LKML seems likely to go un-noticed.  I think
we need a better solution than this.

- Josh Triplett
