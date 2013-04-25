Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3DYGkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:40:17 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:57740 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3DYGkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <1366707297-31309-1-git-send-email-b32955@freescale.com>
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>
Date: Wed, 24 Apr 2013 23:40:14 -0700
Message-ID: <CAN8TOE_5OZ7=hyLn-9hUy9b5ne4HGqra2uAurofB+8kOEuamsw@mail.gmail.com>
Subject: Re: [PATCH V3 0/9] mtd: add datasheet's ECC information to nand_chip{}
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Tue, Apr 23, 2013 at 1:54 AM, Huang Shijie <b32955@freescale.com> wrote:
> v2 --> v3:
>         [0] add a new patch to define the semantics of the two fields.
>         [1] Use the Change Read Column command to remove the "last" argument.
>         [2] simplify the onfi_feature().
>         [3] Use kmalloc() to replace kcalloc().
>         [4] others.

Please see especially my comment on your usage of nand_command_lp. But
other than that, I think that by the time we get to v4, this series
should be good. Anyway, I'll try to reserve any more nitpick-y
comments for minor things to my own follow-up patch(es). Thanks for
the work.

Brian
