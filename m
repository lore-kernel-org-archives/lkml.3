Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaHEKWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:22:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28094 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaHEKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:22:07 -0400
Date: Tue, 5 Aug 2014 13:21:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Philippe De Muyter <phdm@macqel.be>
Cc: Jens Axboe <axboe@kernel.dk>, Fabian Frederick <fabf@skynet.be>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] partitions: aix.c: off by one bug
Message-ID: <20140805102134.GS4804@mwanda>
References: <20140805080959.GA13605@mwanda>
 <20140805101010.GA24281@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805101010.GA24281@frolo.macqel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 12:10:11PM +0200, Philippe De Muyter wrote:
> Did you encounter the bug in real life, or only by code review ?
> 
> If this has a real risk to happen, a pr_warn would be welcome.

Static analysis.

regards,
dan carpenter

