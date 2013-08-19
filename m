Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750759Ab3HSDS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:18:58 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:41435 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3HSDS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130819115401.1f3ce4c2479645d72fb5cb00@canb.auug.org.au>
References: <20130819115401.1f3ce4c2479645d72fb5cb00@canb.auug.org.au>
Date: Sun, 18 Aug 2013 20:18:55 -0700
Message-ID: <CANQSiW2n1qo0YyR_jEYkNkDaDAukH6EEqNYA0nBxO1Sv7aUTAg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the libata tree
From: Terry Suereth <terry.suereth@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per my original patch, "0x3x26" in code should be "0x3726" (as in the
unpatched version).  I refer to "x26" in comments as a forward-looking
assumption, but AFAIK only 3726 and 3826 exist at this time.

terry.suereth@gmail.com


On Sun, Aug 18, 2013 at 6:54 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Tejun,
>
> After merging the libata tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/ata/libata-pmp.c: In function 'sata_pmp_quirks':
> drivers/ata/libata-pmp.c:386:36: error: invalid suffix "x26" on integer constant
>   if (vendor == 0x1095 && (devid == 0x3x26 || devid == 0x3826)) {
>                                     ^
>
> Caused by commit f1a313ad86b9 ("libata: apply behavioral quirks to sil3826 PMP").
>
> I have used the libata tree from next-20130816 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
