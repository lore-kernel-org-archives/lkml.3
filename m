Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaEVPhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:37:52 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:48268 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaEVPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:37:51 -0400
Date: Thu, 22 May 2014 11:37:47 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: declare system_highpri_wq
Message-ID: <20140522153747.GB5065@htj.dyndns.org>
References: <1400748162-13984-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400748162-13984-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 04:42:41PM +0800, Lai Jiangshan wrote:
> system_highpri_wq is exported to modules via EXPORT_SYMBOL_GPL(),
> but it was forgotten to be declared in workqueue.h. So we add the declaration
> and a short description for it.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.16.

Thanks.

-- 
tejun
