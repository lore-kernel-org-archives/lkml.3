Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3GZCid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:38:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:58884 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab3GZCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:38:30 -0400
Date: Fri, 26 Jul 2013 11:38:27 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Olof Johansson <olof@lixom.net>, Linux-SH <linux-sh@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] shdma: fixup sh_dmae_get_partial() calculation
 error
Message-ID: <20130726023827.GA32490@verge.net.au>
References: <1373422152-29976-1-git-send-email-horms+renesas@verge.net.au>
 <20130716012041.GA942@verge.net.au>
 <20130723023907.GC14983@quad.lixom.net>
 <20130723041220.GA22253@verge.net.au>
 <87zjtddgtg.wl%kuninori.morimoto.gx@renesas.com>
 <20130724034009.GA18355@verge.net.au>
 <87d2q8v6fs.wl%kuninori.morimoto.gx@renesas.com>
 <87bo5sv63u.wl%kuninori.morimoto.gx@renesas.com>
 <Pine.LNX.4.64.1307241042360.30777@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1307241042360.30777@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:43:44AM +0200, Guennadi Liakhovetski wrote:
> Hi Morimoto-san
> 
> On Tue, 23 Jul 2013, Kuninori Morimoto wrote:
> 
> > sh_desc->hw.tcr is controlling real data size,
> > and, register TCR is controlling data transfer count
> > which was xmit_shifted value of hw.tcr.
> > Current sh_dmae_get_partial() is calculating in different unit.
> > This patch fixes it.
> > 
> > Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Looks right to me
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>

Thanks, I will queue this up for v3.11 in the fixes-for-v3.11 branch.
