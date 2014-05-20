Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbaETQYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:24:13 -0400
Received: from tex.lwn.net ([70.33.254.29]:34304 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaETQYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:24:12 -0400
Date: Tue, 20 May 2014 10:24:11 -0600
From: Jake Edge <jake@lwn.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Anton Saraev <antonysaraev@gmail.com>
Subject: Re: [PATCH 0/3] staging/skein: more cleanup
Message-ID: <20140520102411.413d565d@chukar.edge2.net>
In-Reply-To: <20140520144757.GA8664@titan.lakedaemon.net>
References: <20140520075612.220a13ae@chukar.edge2.net>
	<20140520144757.GA8664@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 10:47:57 -0400 Jason Cooper wrote:

> Do you have any other series pending for this driver?

No and I won't be doing anything else for the next couple of days --
some darn weekly edition to deal with :)

It seems like most of the straightforward stuff has been dealt with at
this point.  That rats nest of ifdefs in skein_block.c needs attention,
but some kind of tests are needed to ensure nothing breaks before
digging into that ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
