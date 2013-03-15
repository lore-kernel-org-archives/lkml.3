Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab3COVXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 17:23:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36354 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3COVXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 17:23:15 -0400
Date: Sat, 16 Mar 2013 00:22:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 09/50] staging: omap-thermal: make a omap_bandgap_power
 with only one exit point
Message-ID: <20130315212241.GL9138@mwanda>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
 <1363352438-15935-10-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363352438-15935-10-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 08:59:57AM -0400, Eduardo Valentin wrote:
> Change the way the omap_bandgap_power is written so that it has only
> one exit entry (Documentation/CodingStyle).
> 

It's only if there is an unlock or something that you should do
this.  Otherwise the pointless bunny hop is misleading and annoying.

regards,
dan carpenter

