Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaESTV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:21:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34170 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaESTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:21:27 -0400
Date: Mon, 19 May 2014 22:21:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jake Edge <jake@lwn.net>
Cc: Anton Saraev <antonysaraev@gmail.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/06] staging: crypto: skein: rename camelcase vars
Message-ID: <20140519192112.GT16255@mwanda>
References: <cover.1399675444.git.antonysaraev@gmail.com>
 <abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
 <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
 <20140519084028.1527b066@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519084028.1527b066@chukar.edge2.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, Jake, you're right, but if he redoes patch 2/6 then he has to redo
the rest as well.  The bad names were bad in the original code already,
so normally we let people fix things up in follow on patches in that
case.

Is that ok with you?

I totally do appreciate your review comments and agree with them.

regards,
dan carpenter

