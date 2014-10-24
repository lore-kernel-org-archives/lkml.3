Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbaJXCj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:39:59 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48939 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaJXCj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:39:57 -0400
Date: Fri, 24 Oct 2014 11:39:54 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: shmobile: armadillo800eva dts: Enable TMU0
Message-ID: <20141024023953.GF7537@verge.net.au>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
 <1413970709-26607-4-git-send-email-geert+renesas@glider.be>
 <1909016.A6gXeHnn7V@avalon>
 <CAMuHMdUDTk=V=07aTt4YmkcXLWLMwS58_+g15BkQ=Gh9Q7Oibw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUDTk=V=07aTt4YmkcXLWLMwS58_+g15BkQ=Gh9Q7Oibw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 05:17:06PM +0200, Geert Uytterhoeven wrote:
> On Wed, Oct 22, 2014 at 4:58 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > On Wednesday 22 October 2014 11:38:29 Geert Uytterhoeven wrote:
> >> ch0 will be used for clock events and for periodic clock events,
> >> ch1 will be used as clock source.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Simon has posted the same change as "[PATCH v2 20/30] ARM: shmobile:
> > armadillo800eva-reference: Initialise TMU device using DT". You might want to
> > credit him.
> 
> Bummer, didn't look hard enough...
> 
> Simon: what's the reason these hadn't been applied yet?
> Likewise for r8a7778.

Good question. It looks like a number of patches from that series
slipped through the cracks.

I have queued up your r8a7740 patches (patches 2 and 3 of this series)
and my r8a7778 patches. I have also queued up my r8a73a4 CMT1 patches
from the same series that Laurent referred to above.
