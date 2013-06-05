Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3FEJYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:24:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32161 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3FEJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:24:06 -0400
Date: Wed, 5 Jun 2013 12:23:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 2/6] keucr: fix some camelCase warnings
Message-ID: <20130605092311.GO28112@mwanda>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370422206-14961-3-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370422206-14961-3-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:50:02AM +0200, Johannes Schilling wrote:
> resolves checkpatch warning "Avoid CamelCase"
> 

Part of this patch is missing so it will break at link time.

I think this patch came from Laura Lawniczak?  The first line of the
email should say:

From: Laura Lawniczak <laura.lawniczak@googlemail.com>

Then git will give the correct credit.

regards,
dan carpenter


