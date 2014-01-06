Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaAFMch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:32:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57907 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaAFMcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:32:36 -0500
Date: Mon, 6 Jan 2014 13:32:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, preeti.lkml@gmail.com
Subject: Re: [PATCH V2 0/8] sched: cleanup trigger_load_balance
Message-ID: <20140106123219.GI31570@twins.programming.kicks-ass.net>
References: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389008085-9069-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 12:34:37PM +0100, Daniel Lezcano wrote:
> This patchset does a cleanup on the parameters passed from the function
> 'trigger_load_balance' to the underneath functions.

Whee.. it applies ;-)
