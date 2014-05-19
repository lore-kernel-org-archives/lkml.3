Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbaESToV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:44:21 -0400
Received: from tex.lwn.net ([70.33.254.29]:57488 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbaESToU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:44:20 -0400
Date: Mon, 19 May 2014 13:44:18 -0600
From: Jake Edge <jake@lwn.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/06] staging: crypto: skein: rename camelcase vars
Message-ID: <20140519134418.23f917fe@chukar.edge2.net>
In-Reply-To: <20140519192112.GT16255@mwanda>
References: <cover.1399675444.git.antonysaraev@gmail.com>
	<abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
	<dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
	<20140519084028.1527b066@chukar.edge2.net>
	<20140519192112.GT16255@mwanda>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 22:21:12 +0300 Dan Carpenter wrote:
> So, Jake, you're right, but if he redoes patch 2/6 then he has to redo
> the rest as well.  The bad names were bad in the original code already,
> so normally we let people fix things up in follow on patches in that
> case.
> 
> Is that ok with you?

Sure, that seems fine ... I only had fairly minor quibbles, the vast
majority of it is good stuff ...

Not sure it's useful (or even the right way to go about it), but, if it
is, Greg (or Jason or whoever) can add my:

Reviewed-by: Jake Edge <jake@lwn.net>

to the patch set ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
