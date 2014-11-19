Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbaKSNGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:06:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:44941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaKSNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:06:41 -0500
Date: Wed, 19 Nov 2014 16:05:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] PM-wakeup: Deletion of an unnecessary check before
 the function call "wakeup_source_unregister"
Message-ID: <20141119130553.GN4956@mwanda>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546C7E75.9080301@users.sourceforge.net>
 <20141119120915.GM4905@mwanda>
 <546C9319.4040205@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546C9319.4040205@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 01:54:49PM +0100, walter harms wrote:
> device_wakeup_detach returns dev->power.wakeup what is never NULL in this case.
> (not visible here but a few line before exactly this is checked)

Huh?  I don't see a NULL check.

I think you may be confusing "dev->power.can_wakeup" with
"dev->power.wakeup"?

regards,
dan carpenter


