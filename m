Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaDCJoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:44:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49114 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaDCJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:44:07 -0400
Date: Thu, 3 Apr 2014 12:43:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: silvio@port1024.net
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Silvio F <silvio.fricke@gmail.com>
Subject: Re: [PATCH 1/3] staging: vt6655: removed incorrect casting in
 wpactl.c
Message-ID: <20140403094350.GH6991@mwanda>
References: <1395362529-17182-1-git-send-email-cse.cem@gmail.com>
 <cover.1395778852.git.silvio.fricke@gmail.com>
 <9ae62ba7dd9abff5839457e0870f75a53b1bc709.1395778852.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ae62ba7dd9abff5839457e0870f75a53b1bc709.1395778852.git.silvio.fricke@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 09:30:18PM +0100, silvio@port1024.net wrote:
> From: Silvio F <silvio.fricke@gmail.com>

Don't use this header for your own patches.

> 
> This patch fixes the following type of sparse warnings:
> 
> drivers/staging/vt6655/wpactl.c:596:47: warning: cast from restricted gfp_t
> drivers/staging/vt6655/wpactl.c:638:68: warning: cast from restricted gfp_t
> drivers/staging/vt6655/wpactl.c:860:42: warning: cast from restricted gfp_t
> 
> Signed-off-by: Silvio F <silvio.fricke@gmail.com>

We can't verify this is you if you don't send from the same email you
sign off by.  We can't really verify perfectly anyway, of course, but
at least we try do the minimum.

regards,
dan carpenter

