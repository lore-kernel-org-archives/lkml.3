Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbaBXXyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:54:43 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:51971 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaBXXym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:54:42 -0500
Date: Tue, 25 Feb 2014 08:54:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESENT] sh: sh7757lcr: fixup SDHI register size
Message-ID: <20140224235435.GB15664@verge.net.au>
References: <87a9dlqptu.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9dlqptu.wl%kuninori.morimoto.gx@gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 04:20:17PM -0800, Kuninori Morimoto wrote:
> sh7757lcr SDHI register size is 0x100
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
> >> Simon, Geert, Andrew
> 
> Now, no-one is maintenance SH patch.
> Who can apply this patch ??

It seems that Andrew has picked it up.
