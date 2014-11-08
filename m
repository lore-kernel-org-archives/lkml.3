Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaKHUth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 15:49:37 -0500
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:36269 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751231AbaKHUtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 15:49:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:979:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3770:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4362:4383:4388:4395:5007:6261:6742:7514:7809:7875:9025:9388:10004:10400:10848:11232:11658:11914:12043:12294:12296:12517:12519:12555:12663:12679:12740:13018:13019:13069:13161:13229:13311:13357:14096:14097:14106:21080:21094,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coat60_7058221e0362c
X-Filterd-Recvd-Size: 2827
Message-ID: <1415479769.23530.31.camel@perches.com>
Subject: Re: [PATCH v5 06/24] Update MAINTAINERS and CREDITS files with
 amdkfd info
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
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
Date: Sat, 08 Nov 2014 12:49:29 -0800
In-Reply-To: <20141108190125.GA2131@thin>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	 <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
	 <20141108190125.GA2131@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-08 at 11:01 -0800, Josh Triplett wrote:
> On Sat, Nov 08, 2014 at 08:37:27PM +0200, Oded Gabbay wrote:
> >  CREDITS     |  7 +++++++
> >  MAINTAINERS | 10 ++++++++++
> >  2 files changed, 17 insertions(+)
> 
> Given the wide variety of folks who patch CREDITS and MAINTAINERS, might
> I suggest adding CREDITS and MAINTAINERS themselves to the MAINTAINERS
> file (perhaps in the same entry as get_maintainer.pl), so that
> get_maintainer.pl does not fall back to git history for them?

Thanks but:

There is no MAINTAINERS/CREDITS maintainer.

I'm not volunteering.  Maybe you?

But maybe something like this would help:

It has to have both an M: and an S: entry
with maintained or supported to stop get_maintainers
from doing a git history lookup.

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 0662378..584fd69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5881,6 +5881,12 @@ F:	drivers/mailbox/
 F:	include/linux/mailbox_client.h
 F:	include/linux/mailbox_controller.h
 
+MAINTAINERS/CREDITS
+M:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	MAINTAINERS
+F:	CREDITS
+
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 M:	Michael Kerrisk <mtk.manpages@gmail.com>
 W:	http://www.kernel.org/doc/man-pages




