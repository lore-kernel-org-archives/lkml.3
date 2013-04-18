Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965968Ab3DRGxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 02:53:52 -0400
Received: from ozlabs.org ([203.10.76.45]:38217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965920Ab3DRGxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 02:53:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: PranavkumarSawargaonkar <pranavkumar@linaro.org>,
        kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
In-Reply-To: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 18 Apr 2013 16:21:47 +0930
Message-ID: <87wqs02uws.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PranavkumarSawargaonkar <pranavkumar@linaro.org> writes:
> From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>
> This patch implements early printk support for virtio-mmio console devices without using any hypercalls.

This makes some sense, though not sure that early console *read* makes
much sense.  I can see the PCI version of this being useful as well.

The spec definition for this will be interesting, because it can be used
before the device is initialized (something which is generally
verboten).

Cheers,
Rusty.
