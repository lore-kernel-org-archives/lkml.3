Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3JVInk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:43:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41205 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JVInj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:43:39 -0400
Date: Tue, 22 Oct 2013 11:39:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chuong Ngo <cngo.github@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: bcm: removed a developer debug message
 per the TODO list.
Message-ID: <20131022083958.GB5871@mwanda>
References: <1382338644-7984-1-git-send-email-cngo.github@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382338644-7984-1-git-send-email-cngo.github@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 02:57:24AM -0400, Chuong Ngo wrote:
> Removed a debug message as outlined in the TODO list.

The Signed-off-by line is missing.  Run checkpatch.pl over your patch.
Hopefully it should warn you to remove the curly braced because they
are not needed any more.

Otherwise the patch is ok.  Please fix the two issues and resend.

regards,
dan carpenter


