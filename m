Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaIAJfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:35:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34280 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbaIAJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:35:05 -0400
Date: Mon, 1 Sep 2014 12:34:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lnet: lib-ptl.c: sparsa warning: symbol
 not declared
Message-ID: <20140901093454.GD5122@mwanda>
References: <1409478815-6636-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409478815-6636-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 03:23:35PM +0530, Sudip Mukherjee wrote:
> fixed sparse warning of following symbol not declared:
> warning: symbol 'lnet_ptl_cleanup' was not declared. Should it be static?
> warning: symbol 'lnet_ptl_setup' was not declared. Should it be static?
> 
> 
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> As of now these functions are not being called from any other file, so i guess its safe to make them static. 
> 

Next time put this in the patch description instead of below the
cut-off.

regards,
dan carpenter


