Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaEBPgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:36:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37477 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaEBPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:36:21 -0400
Date: Fri, 2 May 2014 11:36:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Xiangliang Yu <yxlraid@gmail.com>
Cc: JBottomley@parallels.com, dan.j.williams@intel.com,
        todd.e.brandt@intel.com, lukasz.dorau@intel.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] libsas: add support for port multiplier
Message-ID: <20140502153617.GH10204@htj.dyndns.org>
References: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398346023-10225-1-git-send-email-yxlraid@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 09:27:03PM +0800, Xiangliang Yu wrote:
> This patch set will support SATA port multiplier(PM) in LIBSAS. 
> 
> LIBSAS is need to implement several key handling to support SATA PM:
> First,low level driver notify libsas that SATA PM is attached to HBA port.
> Then, LIBSAS will need to schedule SATA PMP error handler to scan SATA device
> that is attached to PM, so we must implemet port softreset and PMP reset 
> handling.
> If find SATA devices, we should add the devices into SAS transport layer.
> In order to find SAS domain device we must implemet device type transformation
> : scsi device -> (port number) -> ata device -> domain device. Then, we can
> execute IO operation.
> 
> In these patches, patch 1 is change SATA error handler.
> And patch 2 will add SATA device into SAS layer and implement device type
> transformation. Patch 3 implement SATA functional interface in mvsas.

Please properly thread the patchset from the next posting.

Dan, can you please take a look at this?

Thanks.

-- 
tejun
