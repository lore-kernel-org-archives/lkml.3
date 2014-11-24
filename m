Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaKXJEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:04:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaKXJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:04:07 -0500
Date: Mon, 24 Nov 2014 12:03:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: kernel-audit: Deletion of an unnecessary check before the
 function call "audit_log_end"
Message-ID: <20141124090337.GA7104@mwanda>
References: <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54687F1A.1010809@users.sourceforge.net>
 <20141116111023.GA4905@mwanda>
 <20141116111446.GA4956@mwanda>
 <54688F15.9070703@users.sourceforge.net>
 <20141117073408.GC4905@mwanda>
 <5469B836.8030507@users.sourceforge.net>
 <alpine.DEB.2.02.1411231249310.2261@localhost6.localdomain6>
 <5471E010.2090105@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5471E010.2090105@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 02:24:32PM +0100, SF Markus Elfring wrote:
> > Program analysis tools can also potentially exploit this information,
> 
> The published semantic patch scripts correspond to this desire.
> 

Sorry for that.

I have deleted the Smatch check for this so it no longer warns about:

	if (foo)
		kfree(foo);

regards,
dan carpenter

