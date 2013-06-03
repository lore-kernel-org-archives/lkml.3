Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3FCM6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:58:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33576 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756049Ab3FCM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:58:14 -0400
Message-ID: <1370264293.2025.31.camel@joe-AO722>
Subject: Re: [PATCH V2 2/8] pktcdvd: Convert printk to pr_<level>
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2013 05:58:13 -0700
In-Reply-To: <20130603125057.GB23987@mwanda>
References: <1369978679.10556.36.camel@joe-AO722>
	 <cover.1370048648.git.joe@perches.com>
	 <92da9370f91c4435cd62b71998f6d66db8680596.1370048648.git.joe@perches.com>
	 <20130603095714.GA23987@mwanda> <1370260771.2025.15.camel@joe-AO722>
	 <20130603125057.GB23987@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 15:50 +0300, Dan Carpenter wrote:
> Read it again.  ;)  In the original code, 8 was valid.

Right, I stuffed it up.  Thanks, I'll resubmit later.


