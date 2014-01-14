Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaANHOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:14:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20054 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaANHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:14:40 -0500
Date: Tue, 14 Jan 2014 10:14:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: remove unnecessary braces in pcl711.c
Message-ID: <20140114071424.GK7444@mwanda>
References: <1389669196-15041-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389669196-15041-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 09:13:16PM -0600, Chase Southwood wrote:
> This patch for pcl711.c removes braces causing a checkpatch.pl warning.
> It also removes an empty else arm of an if-else statement.
> 
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> 
> I removed the "else" arm of this statement because it was empty, save
> for the "ignore" comment.  If it is instead preferred kernel style for
> this empty else to remain in, let me know and I will correct this
> patch accordingly.
> 

Nope, it's perfect.  Don't doubt yourself.  Always feel free to change
the code.

regards,
dan carpenter

