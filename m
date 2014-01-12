Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaALD10 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 22:27:26 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:41478 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaALD1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 22:27:24 -0500
Date: Sat, 11 Jan 2014 22:27:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] workqueue: Calling destroy_work_on_stack() to pair
 with INIT_WORK_ONSTACK()
Message-ID: <20140112032721.GA7874@mtj.dyndns.org>
References: <1389084605.3650.66.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389084605.3650.66.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 04:50:05PM +0800, Chuansheng Liu wrote:
> 
> In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
> call destroy_work_on_stack() which frees the debug object to pair
> with INIT_WORK_ONSTACK().
> 
> Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>

Applied to wq/for-3.14.  Thanks.

-- 
tejun
