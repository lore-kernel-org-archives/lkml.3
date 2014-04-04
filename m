Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaDDEsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 00:48:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55414 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaDDEsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 00:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140404031531.GA11828@localhost>
References: <20140404031531.GA11828@localhost>
Date: Fri, 4 Apr 2014 10:18:37 +0530
Message-ID: <CAKohpokJSrJ8iAfk0MUZVFzaZ0OaOTR884=x0eK6QyB_xzC2+Q@mail.gmail.com>
Subject: Re: [hrtimer] BUG: unable to handle kernel NULL pointer dereference
 at 00000010
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jet Chen <jet.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2014 08:45, Fengguang Wu <fengguang.wu@intel.com> wrote:
> [    2.258025] BUG: unable to handle kernel NULL pointer dereference at 00000010
> [    2.258641] IP: [<bd84b778>] hrtimer_force_reprogram+0x3d/0xb1
> [    2.259151] *pde = 00000000
> [    2.259412] Oops: 0000 [#1] DEBUG_PAGEALLOC
> [    2.259786] CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.0-rc1-00080-g336ca19 #9
> [    2.260388] task: bdde5534 ti: bddda000 task.ti: bddda000
> [    2.260830] EIP: 0060:[<bd84b778>] EFLAGS: 00210002 CPU: 0
> [    2.261278] EIP is at hrtimer_force_reprogram+0x3d/0xb1

Hi,

Thanks, this is already fixed in my latest branch. It was pushed yesterday
probably with all fixes :) ..
