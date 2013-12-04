Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab3LDIXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:23:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34450 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3LDIXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:23:10 -0500
Date: Wed, 4 Dec 2013 11:21:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Aldo Iljazi <mail@aldo.io>, Samuel Thibault <samuel.thibault@ens-lyon.org>,
        w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Staging: speakup: synth.c: removed a space
Message-ID: <20131204082137.GR5443@mwanda>
References: <1386101283-14650-1-git-send-email-mail@aldo.io>
 <20131203221703.GE8138@type>
 <20131204043515.GB6909@linux>
 <20131204073824.GP28413@mwanda>
 <1386143115.30493.48.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386143115.30493.48.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You and I generally agree on style preferences...  I think the warning
should be limited to grep " ;$".

I did a grep on the kernel for ' ;' and found 8000 results.  6000 of
them are caught by my semicolon before the newline rule.  The remaining
2000 are assembly, macros, and crappy for loops.

regards,
dan carpenter

