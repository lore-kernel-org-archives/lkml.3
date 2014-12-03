Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaLCMxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:53:01 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53474
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbaLCMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:52:59 -0500
X-IronPort-AV: E=Sophos;i="5.07,507,1413237600"; 
   d="scan'208";a="91511767"
Date: Wed, 3 Dec 2014 13:52:53 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Julia Lawall <julia.lawall@lip6.fr>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, backports@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
In-Reply-To: <20141203124511.GR5048@mwanda>
Message-ID: <alpine.DEB.2.10.1412031352120.2373@hadrien>
References: <20141202085950.GA13434@mwanda> <547F0297.6030202@users.sourceforge.net> <20141203124511.GR5048@mwanda>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Dan Carpenter wrote:

> On Wed, Dec 03, 2014 at 01:31:19PM +0100, SF Markus Elfring wrote:
> >
> > * To which source code place should the word "location" refer to?
> >   - jump source
> >   - jump target
>
> jump target.

I think you mean source?  Or it really is ambiguous.  The example was
err_kmalloc_failed, which seems source-related.

julia
