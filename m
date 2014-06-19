Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbaFSCTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:19:13 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36474 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaFSCTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:19:12 -0400
Date: Wed, 18 Jun 2014 19:19:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Nazarewicz <mina86@mina86.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tsc: get rid of custom DIV_ROUND
In-Reply-To: <1403143116-21755-1-git-send-email-mina86@mina86.com>
Message-ID: <alpine.DEB.2.02.1406181918520.4931@chino.kir.corp.google.com>
References: <1403143116-21755-1-git-send-email-mina86@mina86.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Michal Nazarewicz wrote:

> When invoced for positive values, DIV_ROUND macro defined in
> arch/x86/kernel/tsc.c behaves exactly like DIV_ROUND_CLOSEST from
> include/linux/kernel.h file, so remove the custom macro in favour
> of the shared one.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

Acked-by: David Rientjes <rientjes@google.com>
