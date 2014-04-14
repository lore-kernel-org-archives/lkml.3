Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaDNXPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:15:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38966 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaDNXPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:15:03 -0400
Date: Tue, 15 Apr 2014 01:14:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org
Subject: Re: [PATCH 28/38] tick-sched: remove parameters to
 {__}tick_nohz_task_switch() routines
Message-ID: <20140414231458.GD1877@localhost.localdomain>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
 <5a6a145674295895cabbe355ac0d778c17cfc785.1397492345.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a6a145674295895cabbe355ac0d778c17cfc785.1397492345.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:53:50PM +0530, Viresh Kumar wrote:
> tick_nohz_task_switch() and __tick_nohz_task_switch() routines get task_struct
> passed to them (always for the 'current' task), but they never use it. Remove
> it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Ack.
