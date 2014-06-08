Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaFHMTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 08:19:13 -0400
Received: from ns.horizon.com ([71.41.210.147]:62430 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753476AbaFHMTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 08:19:12 -0400
Date: 8 Jun 2014 08:19:09 -0400
Message-ID: <20140608121909.899.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: dborkman@redhat.com, linux@horizon.com
Subject: Re: [PATCH 2/7] lib/random32.c: Remove excess calls to prandom_u32_state in initialization
Cc: davem@davemloft.net, hannes@stressinduktion.org,
        linux-kernel@vger.kernel.org, shemminger@osdl.org, tytso@mit.edu
In-Reply-To: <539452DA.7060005@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your time and attention on all these comments.

> Fine by me although we simply resembled initialization code from
> GSL here. I think that your subject line is a bit misleading though.

Yes, I had a hard time coming up with a good summary.  I'm removing
*static* calls but not dynamic ones.

How about "don't unroll one-time initialization code"?
Would that be a better way to put it?
