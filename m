Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLOMAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:00:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLOMAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:00:37 -0500
Date: Mon, 15 Dec 2014 14:59:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jeremiah Mahler <jmmahler@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, jun.j.tian@intel.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        octavian.purdila@intel.com, apw@canonical.com, nnk@google.com,
        alan@linux.intel.com
Subject: Re: [PATCH] checkpatch giving bogus advice (was staging: goldfish:
 Fix minor coding style)
Message-ID: <20141215115956.GD4856@mwanda>
References: <e2a3b3ccf85790c865683832698908458931be6a.1418487651.git.loic@loicp.eu>
 <20141213175518.GA28616@hudson.localdomain>
 <20141213182238.GA6979@iron>
 <20141213194647.GA30065@hudson.localdomain>
 <20141215114421.7389d32a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215114421.7389d32a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen any bugs caused by lack of type safety with "!foo"...
I prefer !foo because it is more common in the kernel and I think it's
easier to read but I don't feel strongly about this.

I kind of hate "if (foo != NULL) though, because it's a double negative.
But I really hate when people start adding the "!= 0" on to all their
conditions.

	if (frob() != 0)

Also:

	if (a + b != 0)

People do this all the time instead of "if (a || b)" and I don't know
why...

regards,
dan carpenter

