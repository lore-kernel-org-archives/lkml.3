Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3HEQ2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:28:11 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:46069 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3HEQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:28:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,819,1367964000"; 
   d="scan'208";a="28556602"
Date: Mon, 5 Aug 2013 18:28:08 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: walter harms <wharms@bfs.de>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, corbet@lwn.net, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: adjust code alignment
In-Reply-To: <51FFD1CB.4080907@bfs.de>
Message-ID: <alpine.DEB.2.02.1308051827580.2134@hadrien>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr> <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr> <20130805160645.GI5051@mwanda> <alpine.DEB.2.02.1308051810360.2134@hadrien> <51FFD1CB.4080907@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Aug 2013, walter harms wrote:

> Hello Julia,
>
> IMHO keep the patch as it is.
> It does not change any code that is good.
> Suspicious code that comes up here can be addressed
> in a separate patch.

OK, thanks!

julia
