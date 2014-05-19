Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaESUiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:38:17 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:48487 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaESUiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:38:15 -0400
Date: Mon, 19 May 2014 16:38:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.16] cgroup: disallow debug controller on the
 default hierarchy
Message-ID: <20140519203811.GF27506@mtj.dyndns.org>
References: <20140514233307.GI15690@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514233307.GI15690@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 07:33:07PM -0400, Tejun Heo wrote:
> The debug controller, as its name suggests, exposes cgroup core
> internals to userland to aid debugging.  Unfortunately, except for the
> name, there's no provision to prevent its usage in production
> configurations and the controller is widely enabled and mounted
> leaking internal details to userland.  Like most other debug
> information, the information exposed by debug isn't interesting even
> for debugging itself once the related parts are working reliably.
> 
> This controller has no reason for existing.  This patch implements
> cgrp_dfl_root_inhibit_ss_mask which can suppress specific subsystems
> on the default hierarchy and adds the debug subsystem to it so that it
> can be gradually deprecated as usages move towards the unified
> hierarchy.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
