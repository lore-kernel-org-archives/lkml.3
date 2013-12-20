Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3LTLS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:18:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21686 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3LTLS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:18:58 -0500
Date: Fri, 20 Dec 2013 14:18:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wenliang Fan <fanwlexca@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com, tulinizer@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/bcm: Integer overflow
Message-ID: <20131220111847.GX5443@mwanda>
References: <1387537658-32640-1-git-send-email-fanwlexca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387537658-32640-1-git-send-email-fanwlexca@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 07:07:38PM +0800, Wenliang Fan wrote:
> The checking condition in 'validateFlash2xReadWrite()' is not
> sufficient. A large number invalid would cause an integer overflow and
> pass the condition, which could cause further integer overflows in
> 'Bcmchar.c:bcm_char_ioctl()'.
> 
> Signed-off-by: Wenliang Fan <fanwlexca@gmail.com>

Looks good.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

