Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaGVNRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:17:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28626 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaGVNRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:17:20 -0400
Date: Tue, 22 Jul 2014 16:16:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Cc: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix issues reported by checkpatch
Message-ID: <20140722131654.GP25880@mwanda>
References: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 11:55:39AM +0200, LABBE Corentin wrote:
> Hello
> 
> The drivers/staging/sep/sep_main.c have lots of checkpatch issue.
> This patch series solves them and since there are many, I have splitted corrections in 4 patch.
> 
> Note that this work is done for the Eudyptulla Challenge.
>

Could you resend this with a subject prefix to say which driver you are
modifying?

[PATCH 1/4] Staging: sep:

Also split it apart into patches which do one kind of thing and not just
misc fixes all together.

regards,
dan carpenter

