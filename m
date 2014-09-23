Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaIWOiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:38:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46241 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaIWOiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:38:07 -0400
Date: Tue, 23 Sep 2014 10:38:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: show the pool ID of the default pwq's pool in
 the pool_ids file
Message-ID: <20140923143804.GD19208@htj.dyndns.org>
References: <1411373079-11828-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411373079-11828-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:04:37PM +0800, Lai Jiangshan wrote:
> It seems incomplete if the pool_ids file doesn't include the default
> pwq's pool.  Add it and the result:
> 
> # cat pool_ids 
> 0:9 1:10
> default:8

Hmmm?  default pwq is used only as the fallback if pool switching
fails and the failed nodes will have it assigned to them.  Why would
userland care about something which isn't being used?

Thanks.

-- 
tejun
