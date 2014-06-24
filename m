Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaFXXkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:40:25 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:46403 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaFXXkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:40:23 -0400
Date: Tue, 24 Jun 2014 16:40:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Guenter Roeck <linux@roeck-us.net>
cc: Chen Gang <gang.chen.5i5j@gmail.com>, Liqin Chen <liqin.linux@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rch/score/include/uapi/asm/ptrace.h: Add prefix
 'SCORE_' for related macros
In-Reply-To: <53AA0553.6020909@roeck-us.net>
Message-ID: <alpine.DEB.2.02.1406241639310.22030@chino.kir.corp.google.com>
References: <53A9783C.7050206@gmail.com> <53A98F6F.4080503@roeck-us.net> <alpine.DEB.2.02.1406241549430.29176@chino.kir.corp.google.com> <53AA0553.6020909@roeck-us.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Guenter Roeck wrote:

> That is another question. But for the time being it might be sufficient to
> surround the defines with #if !defined(__KERNEL__) without introducing new
> (and unused) kernel defines.
> 

On the other hand, if no userspace is referencing these, then you could 
just rename them and move them out of the uapi header to 
include/asm/ptrace.h and be done with it.
