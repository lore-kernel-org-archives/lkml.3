Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaA3QK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:10:57 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59748 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaA3QKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:10:55 -0500
Date: Thu, 30 Jan 2014 11:10:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH TRIVIAL] idr: remove unused prototype of idr_free()
Message-ID: <20140130161052.GA16260@htj.dyndns.org>
References: <1391097474-31300-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391097474-31300-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 07:57:54PM +0400, Vladimir Davydov wrote:
> There is no such function. Remove the redundant prototype.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
