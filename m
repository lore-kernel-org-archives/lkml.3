Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaAWVbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:31:13 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38194 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaAWVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:31:12 -0500
Date: Thu, 23 Jan 2014 13:31:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: mingo@kernel.org, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Allocate heap only when required
In-Reply-To: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Viresh Kumar wrote:

> update_flag() routine uses heap only when spread_flag_changed is true. Otherwise
> heap isn't used, but is allocated and freed unnecessarily.
> 
> Fix this by allocating heap only when required.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Acked-by: David Rientjes <rientjes@google.com>
