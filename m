Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaHMNPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:15:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19860 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMNPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:15:05 -0400
Date: Wed, 13 Aug 2014 16:15:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Phong Tran <tranmanphong@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        swetland@google.com, linux-kernel@vger.kernel.org, ccross@android.com,
        joe@perches.com, akpm@linux-foundation.org
Subject: Re: [Patch V2 1/3] staging: android: ion: ion_dummy_driver.c Fix
 coding style
Message-ID: <20140813131505.GV4856@mwanda>
References: <1407860250-9779-1-git-send-email-tranmanphong@gmail.com>
 <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407935380-9324-1-git-send-email-tranmanphong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 08:09:38PM +0700, Phong Tran wrote:
> This patch fix checkpatch.pl warning
> - Replace kzalloc() by kcalloc()
> Tested by compilation.
> 

The patches look ok, but can you resend with better subject lines?
kzalloc() -> kcalloc().
add blank.
remove returns.

Something like that.

regards,
dan carpenter

