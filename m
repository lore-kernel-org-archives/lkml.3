Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbaGNTxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:53:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33346 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbaGNTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:53:31 -0400
MIME-Version: 1.0
In-Reply-To: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com>
References: <000101cf6dc6$3b93d510$b2bb7f30$@samsung.com>
Date: Mon, 14 Jul 2014 14:53:27 -0500
Message-ID: <CAOZdJXWCu-zHuQoAUdiieqsKqCfG9BsZariFqQP=NCgQP-zpNA@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] arm64: Introduce VA_BITS and translation level options
From: Timur Tabi <timur@codeaurora.org>
To: Jungseok Lee <jays.lee@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, Catalin.Marinas@arm.com,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, steve.capper@linaro.org,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        ilho215.lee@samsung.com,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 4:40 AM, Jungseok Lee <jays.lee@samsung.com> wrote:
> This patch adds virtual address space size and a level of translation
> tables to kernel configuration. It facilicates introduction of
> different MMU options, such as 4KB + 4 levels, 16KB + 4 levels and
> 64KB + 3 levels, easily.

Is there a reason why this patch has not yet been picked up?  It
appears to work just fine, and the change is necessary for ARM SOCs
that support large amounts of memory.  It seems weird that after so
many versions, reviews, and ACKs, that it still not in linux-next.
