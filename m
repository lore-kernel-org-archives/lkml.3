Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaAZNjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:39:40 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:42387 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaAZNjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:39:39 -0500
MIME-Version: 1.0
In-Reply-To: <1390733658.3059.10.camel@laptop>
References: <1390733658.3059.10.camel@laptop>
Date: Sun, 26 Jan 2014 14:39:38 +0100
Message-ID: <CAJAFBLBONBLnMnC3Dq8fad4vAUPJPOjp6+5TEzdUAC=Dq6x7pQ@mail.gmail.com>
Subject: Re: [PATCH] for_each macros correctness
From: Fubo Chen <fubo.chen@gmail.com>
To: Jose Alonso <joalonsof@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 11:54 AM, Jose Alonso <joalonsof@gmail.com> wrote:
> I observed that there are for_each macros that do an extra memory access
> beyond the defined area.
> Normally this does not cause problems.
> But, this can cause exceptions. For example: if the area is allocated at
> the end of a page and the next page is not accessible.
>
> For correctness, I suggest changing the arguments of the 'for loop' like
> others 'for_each' do in the kernel.

Does this patch fix a kernel crash when using gcc 4.8 like the patch
in http://lkml.org/lkml/2014/1/21/146 ?

Thanks,

Fubo.
