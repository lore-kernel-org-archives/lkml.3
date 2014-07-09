Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaGIIJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:09:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42450 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaGIIJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:09:50 -0400
Date: Wed, 9 Jul 2014 11:09:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        peter.senna@gmail.com, linux-kernel@vger.kernel.org, rmfrfs@gmail.com,
        teobaluta@gmail.com, Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: Re: [PATCH v2 1/4] staging: rtl8192u: Remove useless return
 statement in r819xU_phy.c
Message-ID: <20140709080943.GT25880@mwanda>
References: <20140708100142.GR25934@mwanda>
 <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
 <1404885860-19468-2-git-send-email-sanjeevsharmaengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404885860-19468-2-git-send-email-sanjeevsharmaengg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches look ok now.  The only thing is that the changelogs are
a little off.

On Wed, Jul 09, 2014 at 11:34:17AM +0530, sanjeev sharma wrote:
> From: sanjeev sharma <sanjeev_sharma@mentor.com>

Don't use the From header unless you are sending patches on behalf of
someone else.  It's better if you can configure your email client so you
can send the patches from your @mentor.com address.  It would be better
if the names were capitalized.

> 
> This is a patch to the r819xU_phy.c file that remove unneeded return statements in code.

Please line wrap the changelog at 72 characters (the same as email).
Otherwise Greg sometimes fixes them manually...

But the patches themselves are nice now.

regards,
dan carpenter

