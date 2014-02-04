Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaBDIXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:23:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26849 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaBDIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:23:27 -0500
Date: Tue, 4 Feb 2014 11:23:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SeongJae Park <sj38.park@gmail.com>
Cc: gregkh@linuxfoundation.org, dulshani.gunawardhana89@gmail.com,
        shaun@XResource.ca, lisa@xenapiadmin.com, sima.baymani@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: cxt1e1: fix pointer-integer size mismatch
 warning
Message-ID: <20140204082317.GH26722@mwanda>
References: <1391497286-6951-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391497286-6951-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 04:01:26PM +0900, SeongJae Park wrote:
> Fix the pointer-integer size mismatch warning below:
> 	drivers/staging/cxt1e1/functions.c: In function ‘VMETRO_TRACE’:
> 	drivers/staging/cxt1e1/functions.c:268:21: warning: cast from pointer
> 			to integer of different size [-Wpointer-to-int-cast]
> 	     u_int32_t   y = (u_int32_t) x;
> 			     ^

This function isn't called.  Just delete it from here and also from the
.h file.

regards,
dan carpenter

