Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbbAFKE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:04:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35338 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbbAFKE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:04:58 -0500
Date: Tue, 6 Jan 2015 13:04:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dominique Martinet <dominique.martinet@cea.fr>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [V9fs-developer] [PATCH 1/8] fs/9p: Deletion of unnecessary
 checks before the function call "p9_client_clunk"
Message-ID: <20150106100434.GH15033@mwanda>
References: <5317A59D.4@users.sourceforge.net>
 <54A01326.3050306@users.sourceforge.net>
 <54A06AB9.4020505@users.sourceforge.net>
 <20150105112206.GC15033@mwanda>
 <54AB02F3.5020308@users.sourceforge.net>
 <alpine.DEB.2.02.1501052239290.2025@localhost6.localdomain6>
 <54AB0844.5090405@users.sourceforge.net>
 <alpine.DEB.2.02.1501052257270.2025@localhost6.localdomain6>
 <20150106081253.GA22484@u-galfione>
 <20150106092719.GB22484@u-galfione>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106092719.GB22484@u-galfione>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:27:19AM +0100, Dominique Martinet wrote:
> (All other patches in the set look good to me at second glance, now.
> To answer Dan's mail, none of these are bug fix as far as I've seen,
> just avoiding unnecessary checks for null or calls+check/warn depending
> on whether you apply patch #1 first)

You're right.  The patch set introduces bugs then fixes them later.

regards,
dan carpenter

