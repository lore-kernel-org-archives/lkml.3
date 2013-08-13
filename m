Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3HMExE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 00:53:04 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:36642
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab3HMExB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 00:53:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,866,1367964000"; 
   d="scan'208";a="23810548"
Date: Tue, 13 Aug 2013 06:52:56 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@kernel.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Eric Miao <eric.y.miao@gmail.com>,
        robert.jarzmik@free.fr, kernel-janitors@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/16 v2] sound/soc/pxa/mioa701_wm9713.c: Avoid using
 ARRAY_AND_SIZE(e) as a function argument
In-Reply-To: <20130812214050.GI6427@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1308130652080.1997@localhost6.localdomain6>
References: <1376340564-7975-1-git-send-email-Julia.Lawall@lip6.fr> <20130812214050.GI6427@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Mark Brown wrote:

> On Mon, Aug 12, 2013 at 10:49:24PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
> > arity of the called function.
> 
> What is the difference between this and the patch I applied the other
> day?

Sorry, it should have also removed the local definition of ARRAY_AND_SIZE?  
I thought that was in the commit message.

julia
