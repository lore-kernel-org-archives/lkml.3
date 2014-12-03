Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaLCNUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:20:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36212 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaLCNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:20:23 -0500
Date: Wed, 3 Dec 2014 16:20:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Coccinelle <cocci@systeme.lip6.fr>, backports@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [patch] CodingStyle: add some more error handling guidelines
Message-ID: <20141203132002.GT5048@mwanda>
References: <20141202085950.GA13434@mwanda>
 <547F0297.6030202@users.sourceforge.net>
 <20141203124511.GR5048@mwanda>
 <547F0977.7090908@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547F0977.7090908@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry.  I misread your email.  If the code looks like this:

	foo = kmalloc();
	if (!foo)
		goto kmalloc_failed;

The "kmalloc_failed" doesn't add any information.  We can see that
kmalloc failed from the context.

regards,
dan carpenter

