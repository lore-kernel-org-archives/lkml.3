Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaBXHkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:40:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46563 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXHkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:40:12 -0500
Date: Mon, 24 Feb 2014 10:39:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Roddick <dgroddick@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        hsweeten@visiongravers.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: Fix coding style issue in poc.c This is
 a patch to remove unneccessary space after function pointer name found with
 checkpatch.pl
Message-ID: <20140224073951.GB26722@mwanda>
References: <1393196475-9684-1-git-send-email-dgroddick@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393196475-9684-1-git-send-email-dgroddick@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leave a blank line between the subject and the body of the changelog.
The signed-off-by line is missing.

regards,
dan carpenter

