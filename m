Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbaCYLs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:48:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:12026 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753119AbaCYLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:48:56 -0400
Date: Tue, 25 Mar 2014 11:49:36 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: "lwcheng@cs.hku.hk" <lwcheng@cs.hku.hk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Question] Linux CFS sched_entity
Message-ID: <20140325114936.GA29592@e103034-lin>
References: <20140317125541.17043cxzmlnxa0ys@intranet.cs.hku.hk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317125541.17043cxzmlnxa0ys@intranet.cs.hku.hk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:55:41AM +0000, lwcheng@cs.hku.hk wrote:
> In what situations does cfs_rq->curr point to a task_group?
> What's the sense? I thought it should always contain a "real" task.

In nested task groups cfs_rq->curr may point to a sched_entity which is
a nested task group (cfs_rq).

parent_group -> child_group -> task

Morten
