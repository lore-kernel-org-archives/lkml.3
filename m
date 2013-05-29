Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965045Ab3E2Hz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 03:55:59 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39964 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850Ab3E2Hz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 03:55:56 -0400
Date: Wed, 29 May 2013 10:55:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: Re: [patch] ceph: tidy ceph_mdsmap_decode() a little
Message-ID: <20130529075538.GE23987@mwanda>
References: <20130529062213.GF23932@mwanda>
 <51A5AB81.5070908@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A5AB81.5070908@bfs.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 09:17:21AM +0200, walter harms wrote:
> personally i would go for:
> 		info->export_targets = NULL;
> and remove the else below.
> 

I don't have strong feelings one way or the other, but honestly, I
think the way I sent it is more clear.

regards,
dan carpenter

