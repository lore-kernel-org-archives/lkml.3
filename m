Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbaENLQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:16:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbaENLQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:16:43 -0400
Date: Wed, 14 May 2014 14:16:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pawel Lebioda <pawel.lebioda89@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix missing a blank line after declaration for usbip
Message-ID: <20140514111626.GD22735@mwanda>
References: <20140510145650.GA30555@ThinkPad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510145650.GA30555@ThinkPad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Send the patch inline so it can be applied automatically with git am.

On Sat, May 10, 2014 at 04:56:51PM +0200, Pawel Lebioda wrote:
> Hi,
> 
> Please find attached patch which fixes most of 
> "Missing blank line after declaration" in drivers/staging/usbip
> directory.
> 
> There are still two WARNINGS reported which refers to the struct
> declaration, and it seems to be a problem with the checkpatck.pl script.
> 
> Regards
> Pawel Lebioda

> >From 6fba281794ce0466e88c785123f906b7d3654bc2 Mon Sep 17 00:00:00 2001
> From: Pawel Lebioda <pawel.lebioda89@gmail.com>
> Date: Sat, 10 May 2014 16:35:50 +0200
> Subject: [PATCH] Fix missing a blank line after declaration for usbip
> 

Subject should have a subsystem prefix.

[PATCH] Staging: usbip: missing a blank lines after declarations

There is no Signed-off-by line.

Put the stuff from the email into the changelog.

regards,
dan carpenter

