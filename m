Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaGPXUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:20:06 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:37508 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbaGPXUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:20:01 -0400
MIME-Version: 1.0
In-Reply-To: <1405263538-27589-3-git-send-email-richard@nod.at>
References: <1405263538-27589-1-git-send-email-richard@nod.at>
	<1405263538-27589-3-git-send-email-richard@nod.at>
Date: Wed, 16 Jul 2014 16:20:00 -0700
Message-ID: <CA+8MBbKA5UppTjLP6JYAeLMAyeUPBfF73j91xDCfoF_Vewy5=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ia64: Remove Linux/x86 domain support
From: Tony Luck <tony.luck@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 7:58 AM, Richard Weinberger <richard@nod.at> wrote:

Did you read the comment?

> -/*
> - * Even when CONFIG_IA32_SUPPORT is not enabled it is
> - * useful to have the Linux/x86 domain registered to
> - * avoid an attempted module load when emulators call
> - * personality(PER_LINUX32). This saves several milliseconds
> - * on each such call.
> - */

I don't know if there are still people using ia32el to run x86 binaries
on ia64 ... but if there are, they may be sad at the extra delays.

-Tony
