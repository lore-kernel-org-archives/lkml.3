Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3LaLBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 06:01:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42993 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab3LaLBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 06:01:33 -0500
Date: Tue, 31 Dec 2013 14:01:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arthur Schwalbenberg <arthurs578@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        lisa@xenapiadmin.com, linux-kernel@vger.kernel.org,
        himangi774@gmail.com
Subject: Re: [PATCH] Staging: bcm: Fixed excessive line lengths cleaned up
 some code
Message-ID: <20131231110127.GS28413@mwanda>
References: <1388404494-27647-1-git-send-email-arthurs578@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388404494-27647-1-git-send-email-arthurs578@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 06:54:54AM -0500, Arthur Schwalbenberg wrote:
> 	This is a patch to the Adapter.h file that fixes up excesssive
> 	line length warnings found by the checkpatch.pl tool
> 
> 	Signed off by: Arthur Schwalbenberg <arthurs578@gmail.com>

Don't indent the changelog like this.

Also the patch is wrong and breaks the driver.  You can't re-arrange
struct members which are a part of the user space API.

regards,
dan carpenter
