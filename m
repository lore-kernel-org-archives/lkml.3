Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3K2WZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 17:25:41 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56644 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3K2WZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 17:25:37 -0500
Date: Fri, 29 Nov 2013 17:25:33 -0500
From: Tejun Heo <tj@kernel.org>
To: Michele Baldessari <michele@acksyn.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate
 Momentus SpinPoint M8
Message-ID: <20131129222533.GL21755@mtj.dyndns.org>
References: <1385406014-4877-1-git-send-email-michele@acksyn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385406014-4877-1-git-send-email-michele@acksyn.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 07:00:14PM +0000, Michele Baldessari wrote:
> We've received multiple reports in Fedora via (BZ 907193)
> that the Seagate Momentus SpinPoint M8 errors out when enabling AA:
> [    2.555905] ata2.00: failed to enable AA (error_mask=0x1)
> [    2.568482] ata2.00: failed to enable AA (error_mask=0x1)
> 
> Add the ATA_HORKAGE_BROKEN_FPDMA_AA for this specific harddisk.
> 
> Reported-by: Nicholas <arealityfarbetween@googlemail.com>
> Signed-off-by: Michele Baldessari <michele@acksyn.org>
> Tested-by: Nicholas <arealityfarbetween@googlemail.com>

Applied to libata/for-3.13-fixes w/ stable cc'd.

Thanks!

-- 
tejun
