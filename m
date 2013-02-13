Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3BMTC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:02:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43159 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3BMTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:02:25 -0500
Date: Wed, 13 Feb 2013 14:02:22 -0500 (EST)
Message-Id: <20130213.140222.1699052281796374631.davem@davemloft.net>
To: nschichan@freebox.fr
Cc: mgherzan@gmail.com, linux@arm.linux.org.uk, daniel.borkmann@tik.ee.ethz.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360776645-14726-1-git-send-email-nschichan@freebox.fr>
References: <1360776125-14542-1-git-send-email-nschichan@freebox.fr>
	<1360776645-14726-1-git-send-email-nschichan@freebox.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Schichan <nschichan@freebox.fr>
Date: Wed, 13 Feb 2013 18:30:39 +0100

> The original code was generating an lsl instructions using the value
> of ARM_R8 (skb_headlen, possibly uninitialized if no skb_headlen
> access was required) as a shift amount.
> 
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>

ARM folks do you want to pick this up or would you like me to
apply it to the 'net' tree?
