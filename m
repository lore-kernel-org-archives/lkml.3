Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaFQBZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 21:25:50 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50034 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaFQBZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 21:25:49 -0400
Date: Mon, 16 Jun 2014 18:25:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Guenter Roeck <linux@roeck-us.net>
cc: Russell King <linux@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Fix build warning
In-Reply-To: <1402677635-28406-1-git-send-email-linux@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1406161825360.21018@chino.kir.corp.google.com>
References: <1402677635-28406-1-git-send-email-linux@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Guenter Roeck wrote:

> If compiled with W=1, the following warning is seen in arm builds.
> 
> arch/arm/kernel/topology.c:278:25: warning:
> 	type qualifiers ignored on function return type
> 
> This is caused by a function returning 'const int', which doesn't
> make sense to gcc. Drop 'const' to fix the problem.
> 
> Reported-by: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: David Rientjes <rientjes@google.com>
