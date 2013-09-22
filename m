Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab3IVQy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 12:54:26 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56397 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3IVQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 12:54:24 -0400
Date: Sun, 22 Sep 2013 12:54:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: joe@perches.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ahci: Changing two module params with static and
 __read_mostly
Message-ID: <20130922165420.GC30946@htj.dyndns.org>
References: <1379436518.26153.31.camel@cliu38-desktop-build>
 <1379506909.26153.33.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379506909.26153.33.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 08:21:49PM +0800, Chuansheng Liu wrote:
> 
> Here module parameters ahci_em_messages and devslp_idle_timeout can
> be set as static and __read_mostly.
> 
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>

Applied to libata/for-3.13.  Thanks.

-- 
tejun
