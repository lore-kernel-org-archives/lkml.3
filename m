Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaBMVmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:42:31 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:44181 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaBMVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:41:58 -0500
Date: Thu, 13 Feb 2014 16:41:46 -0500
From: Tejun Heo <tj@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 48/73] drivers/ata: delete non-required instances of
 include <linux/init.h>
Message-ID: <20140213214146.GI17608@htj.dyndns.org>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-49-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390339396-3479-49-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:22:51PM -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: linux-ide@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied to libata/for-3.15.

Thanks.

-- 
tejun
