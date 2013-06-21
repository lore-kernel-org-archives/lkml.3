Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423652Ab3FUSmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 14:42:20 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53120 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423388Ab3FUSmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 14:42:18 -0400
Date: Fri, 21 Jun 2013 11:42:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: [PATCH 1/4] ata_piix: IDE-mode SATA patch for Intel Coleto Creek
 DeviceIDs
Message-ID: <20130621184214.GB1763@htj.dyndns.org>
References: <1371684337-6341-1-git-send-email-seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371684337-6341-1-git-send-email-seth.heasley@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 04:25:37PM -0700, Seth Heasley wrote:
> This patch adds the IDE-mode SATA DeviceIDs for the Intel Coleto Creek PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Applied to libata/for-3.10-fixes with -stable cc'd.  Note that
for-3.10-fixes at this point is scheduled to be pushed when v3.11-rc1
opens.

Thanks.

-- 
tejun
