Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaFIHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:16:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaFIHQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:16:27 -0400
Date: Mon, 9 Jun 2014 10:16:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Wood <tommyandrena@gmail.com>
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] staging: ft1000: ft1000-usb: ft1000_debug.c:
 Misc. fixes.
Message-ID: <20140609071615.GF5015@mwanda>
References: <20140602103056.GY15585@mwanda>
 <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
 <1402110138-13713-6-git-send-email-tommyandrena@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402110138-13713-6-git-send-email-tommyandrena@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 08:02:18PM -0700, Thomas Wood wrote:
> Remove initialization of static value.
> Invert the empty if statement's test to replace the else statement.
> Remove parentheses from a return statement.
> Fix some code indentation.
> 
> Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
> ---
> 
> I'm pretty sure that the indentation was caused by a mistake by me earlier on in the patch set, so I'm fixing it now.
> 

No....  That's not the right thing.  If you cause the mistake earlier,
then redo the earlier patch.

Also I feel like fixing the indent here makes the patch into a "does too
many things in one go patch."  This patch is on the limit anyway.

regards,
dan carpenter
