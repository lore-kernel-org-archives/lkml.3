Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaKSSTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:19:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37242 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaKSSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:19:37 -0500
Date: Wed, 19 Nov 2014 13:19:33 -0500 (EST)
Message-Id: <20141119.131933.594403961160605240.davem@davemloft.net>
To: dan.carpenter@oracle.com
Cc: elfring@users.sourceforge.net, herbert@gondor.apana.org.au,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: net: xfrm: Deletion of an unnecessary check before the
 function call "ipcomp_free_tfms"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141119101003.GL4905@mwanda>
References: <20141119084542.GK4905@mwanda>
	<546C6823.50900@users.sourceforge.net>
	<20141119101003.GL4905@mwanda>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 10:19:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 19 Nov 2014 13:10:03 +0300

> I have come to view you as a very clever troll.

+1
