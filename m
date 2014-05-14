Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbaENRMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:12:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57752 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaENRMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:12:53 -0400
Date: Wed, 14 May 2014 13:12:50 -0400
From: "'Tejun Heo'" <tj@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Remove deprecated flush[_delayed]_work_sync()
Message-ID: <20140514171250.GE15690@htj.dyndns.org>
References: <002001cf6f2f$12170bc0$36452340$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002001cf6f2f$12170bc0$36452340$%han@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:43:37PM +0900, Jingoo Han wrote:
> flush[_delayed]_work_sync() were deprecated by 4382973 ("workqueue:
> deprecate flush[_delayed]_work_sync()") and have been deprecated
> for a long time. In addition, these are not used anymore. So,
> let's remove these functions.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied to wq/for-3.16.

Thanks.

-- 
tejun
