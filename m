Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3LEIk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:40:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39412 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab3LEIk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:40:56 -0500
Date: Thu, 5 Dec 2013 11:40:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Subject: Re: [PATCH v1 3/9] staging: android: binder: Add cmd == CMD_NAME
 handling
Message-ID: <20131205084042.GW28413@mwanda>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-4-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386180581-6710-4-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:09:35PM +0000, Serban Constantinescu wrote:
> This patch modifies the functions that need to be passed the explicit
> command to use a boolean flag. This way we can reuse the code for 64bit
> compat commands.
> 

I don't understand this at all.  cmd seems like it should be 32 bits
on both arches.

regards,
dan carpenter

