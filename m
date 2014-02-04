Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaBDIsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:48:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37374 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaBDIsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:48:02 -0500
Date: Tue, 4 Feb 2014 11:47:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SeongJae Park <sj38.park@gmail.com>
Cc: gregkh@linuxfoundation.org, dulshani.gunawardhana89@gmail.com,
        shaun@XResource.ca, lisa@xenapiadmin.com, sima.baymani@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: cxt1e1: remove unnecessary function,
 VMETRO_TRACE
Message-ID: <20140204084756.GE26776@mwanda>
References: <1391502999-7349-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391502999-7349-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 05:36:39PM +0900, SeongJae Park wrote:
> VMETRO_TRACE isn't called from anywhere. So delete it.
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

