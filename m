Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaAFHv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:51:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48944 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaAFHv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:51:28 -0500
Date: Mon, 6 Jan 2014 10:51:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, andrea.merello@gmail.com,
        gregkh@linuxfoundation.org, rusty@rustcorp.com.au,
        linville@tuxdriver.com, linux-kernel@vger.kernel.org,
        teobaluta@gmail.com, Dan LaManna <dan.lamanna@gmail.com>
Subject: Re: [PATCH] Staging: rtl8187se: fix styling issues in r8180_wx.c
Message-ID: <20140106075117.GJ30234@mwanda>
References: <1388956656-10790-1-git-send-email-dan.lamanna@gmail.com>
 <20140105214555.GH30234@mwanda>
 <1388962160.5808.33.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388962160.5808.33.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 02:49:20PM -0800, Joe Perches wrote:
> 
> Needs parentheses
> 
> 	if ((src->capability & WLAN_CAPABILITY_IBSS) !=
> 	    (dst->capability & WLAN_CAPABILITY_IBSS))
> 

Yeah.  You are right.

regards,
dan carpenter

