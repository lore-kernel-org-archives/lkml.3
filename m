Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaKQNyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:54:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41288 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaKQNpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:36 -0500
Date: Mon, 17 Nov 2014 16:45:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] kernel-audit: Deletion of an unnecessary check
 before the function call "audit_log_end"
Message-ID: <20141117134515.GE4905@mwanda>
References: <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54687F1A.1010809@users.sourceforge.net>
 <20141116111023.GA4905@mwanda>
 <20141116111446.GA4956@mwanda>
 <54688F15.9070703@users.sourceforge.net>
 <20141117073408.GC4905@mwanda>
 <5469B836.8030507@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5469B836.8030507@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 09:56:22AM +0100, SF Markus Elfring wrote:
> > You removed the statement from "if (foo) kfree_fsm(foo);" so now it
> > prints a warning.
> > 
> > drivers/s390/net/fsm.c
> 
> Would it be better to continue the clarification of affected implementation details
> under the discussion topic "s390/net: Deletion of unnecessary checks before two function calls"?
> 

What do you want me to clarify?  Do you still not see the bug?

regards,
dan carpenter

