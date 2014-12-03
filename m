Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaLCNQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:16:16 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33886 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaLCNQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:16:13 -0500
Date: Wed, 3 Dec 2014 16:15:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, backports@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
Message-ID: <20141203131549.GS5048@mwanda>
References: <20141202085950.GA13434@mwanda>
 <547F0297.6030202@users.sourceforge.net>
 <20141203124511.GR5048@mwanda>
 <alpine.DEB.2.10.1412031352120.2373@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1412031352120.2373@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 01:52:53PM +0100, Julia Lawall wrote:
> On Wed, 3 Dec 2014, Dan Carpenter wrote:
> 
> > On Wed, Dec 03, 2014 at 01:31:19PM +0100, SF Markus Elfring wrote:
> > >
> > > * To which source code place should the word "location" refer to?
> > >   - jump source
> > >   - jump target
> >
> > jump target.
> 
> I think you mean source?  Or it really is ambiguous.  The example was
> err_kmalloc_failed, which seems source-related.

Yeah.  You're right.  I misread Markus's email.  The goto location is
where the goto is.  The label location is where the label is.

regards,
dan carpenter
