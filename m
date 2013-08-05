Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3HERGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:06:13 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3HERGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:06:11 -0400
Date: Mon, 5 Aug 2013 20:05:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Julia Lawall <julia.lawall@lip6.fr>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, corbet@lwn.net, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: adjust code alignment
Message-ID: <20130805170544.GO5102@mwanda>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
 <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr>
 <20130805160645.GI5051@mwanda>
 <alpine.DEB.2.02.1308051810360.2134@hadrien>
 <51FFD1CB.4080907@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FFD1CB.4080907@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:24:43PM +0200, walter harms wrote:
> Hello Julia,
> 
> IMHO keep the patch as it is.
> It does not change any code that is good.
> Suspicious code that comes up here can be addressed
> in a separate patch.
> 

Gar... No, if we silence static checker warnings without fixing the
bug then we are hiding real problems and making them more difficult
to find.

Just drop this chunk.

regards,
dan carpenter

