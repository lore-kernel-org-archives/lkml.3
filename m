Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaKHTCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 14:02:09 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42050 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaKHTCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 14:02:07 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 8 Nov 2014 11:01:51 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
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
        Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH v5 06/24] Update MAINTAINERS and CREDITS files with
 amdkfd info
Message-ID: <20141108190125.GA2131@thin>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
 <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 08:37:27PM +0200, Oded Gabbay wrote:
>  CREDITS     |  7 +++++++
>  MAINTAINERS | 10 ++++++++++
>  2 files changed, 17 insertions(+)

Given the wide variety of folks who patch CREDITS and MAINTAINERS, might
I suggest adding CREDITS and MAINTAINERS themselves to the MAINTAINERS
file (perhaps in the same entry as get_maintainer.pl), so that
get_maintainer.pl does not fall back to git history for them?

- Josh Triplett
