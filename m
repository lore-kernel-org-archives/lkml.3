Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbaD2Rcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:32:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25703 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbaD2Rcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:32:32 -0400
Date: Tue, 29 Apr 2014 20:32:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Seunghun Lee <waydi1@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix missing a blank line after
 declarations
Message-ID: <20140429173221.GE26890@mwanda>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 01:59:12AM +0900, Seunghun Lee wrote:
> This patch fixes "Missing a blank line after declarations" warnings.
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>

Quite a few of these are false checkpatch.pl false positives.  Just
ignore the false positives.

regards,
dan carpenter

