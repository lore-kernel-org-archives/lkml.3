Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaELFtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:49:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:38782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbaELFtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:49:02 -0400
Message-ID: <1399873724.17624.80.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix "attempt to move .org backwards" error
 (again)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Date: Mon, 12 May 2014 15:48:44 +1000
In-Reply-To: <5370537F.8020901@roeck-us.net>
References: <1399680478-4970-1-git-send-email-linux@roeck-us.net>
	 <1399867920.17624.73.camel@pasglop> <5370537F.8020901@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-11 at 21:52 -0700, Guenter Roeck wrote:
> Oh well, it was worth a try. Can you give me an example for a failing
> configuration ?

My g5 config which is close to g5_defconfig with PR KVM enabled.

In any case, see my other messages. I'm waiting for all my test builders
to come back and if it's clear I'll post a new patch.

Cheers,
Ben.


