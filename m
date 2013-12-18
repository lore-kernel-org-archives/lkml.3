Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3LRJnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:43:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36916 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3LRJnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:43:20 -0500
Date: Wed, 18 Dec 2013 09:43:14 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        James Bottomley <JBottomley@Parallels.com>
Subject: Re: [PATCH 3.5 037/103] [SCSI] Disable WRITE SAME for RAID and
 virtual host adapter drivers
Message-ID: <20131218094314.GA4452@hercules>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
 <1387304012-23805-38-git-send-email-luis.henriques@canonical.com>
 <yq1vbyn6s8p.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1vbyn6s8p.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Tue, Dec 17, 2013 at 05:13:26PM -0500, Martin K. Petersen wrote:
> >>>>> "Luis" == Luis Henriques <luis.henriques@canonical.com> writes:
> 
> Luis> 3.5.7.28 -stable review patch.  If anyone has any objections,
> Luis>          please let me know.
> 
> Luis>   - dropped changes to drivers/scsi/sd.c ]
> 
> WRITE SAME support didn't go in until 3.7. And without the sd.c pieces
> the patch doesn't actually do anything.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering

Thank you for your review.  Looks like this patch doesn't make sense in the
3.5 kernel, so I'll just drop it.

Cheers,
--
Luis
