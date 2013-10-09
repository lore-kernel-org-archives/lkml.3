Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3JIDkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:40:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50246 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3JIDkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:40:15 -0400
Date: Wed, 9 Oct 2013 12:40:12 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: shmobile: emev2: Add clock tree description
 in DT
Message-ID: <20131009034011.GN15065@verge.net.au>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
 <20131008143307.9270bd3307a0524d89088c2a@ops.dti.ne.jp>
 <CANqRtoT0EYcn6U_-Zin7eryiYGwb0C16AyLXtnsQ0Srt1PTG=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoT0EYcn6U_-Zin7eryiYGwb0C16AyLXtnsQ0Srt1PTG=w@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:54:26PM +0900, Magnus Damm wrote:
> On Tue, Oct 8, 2013 at 2:33 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> > Add minimum clock tree description to .dts file.
> > This provides same set of clocks as current sh-clkfwk version .c
> > code does.
> >
> > Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>

Thanks.

I plan to add this patch to a new topic branch,
topic/emev2-common-clock, in the renesas tree and
queue it up from there for inclusion in mainline
if/when the first patch of this series is accepted
by Mike Turquette.
