Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3ETO0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:26:38 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54361 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab3ETO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:26:34 -0400
Message-ID: <1369059993.3301.174.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against
 spraying attacks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 May 2013 07:26:33 -0700
In-Reply-To: <20130520141941.GA16412@breakpoint.cc>
References: <1368844623.3301.142.camel@edumazet-glaptop>
	 <20130520141941.GA16412@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 16:19 +0200, Florian Westphal wrote:

> What about emitting additional instructions at random locations in the
> generated code itself?
> 
> Eg., after every instruction, have random chance to insert
> 'xor $0xcc,%al; xor $0xcc,%al', etc?

This will be the latest thing I'll do.

Frankly, whole point of BPF JIT is speed.

If we have slow code, just use the interpretor instead.



