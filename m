Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513Ab3DSOBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:01:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:56650 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030427Ab3DSOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:01:29 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:6531:55f7:c8f6:104b]
In-Reply-To: <20130419164636.0d2405ca5fd927f1ba31fe40@canb.auug.org.au>
References: <20130419164636.0d2405ca5fd927f1ba31fe40@canb.auug.org.au>
Date: Fri, 19 Apr 2013 07:01:28 -0700
Message-ID: <CAOesGMhUTyPdNo=yaRqEv+Zhf7ga8e-R0asbnuje_LioWbqsgg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:46 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the arm-soc tree, today's linux-next build (powerpc ppc64_defconfig)
> failed like this:
>
> powerpc64-linux-ld: cannot find drivers/pci/host/built-in.o: No such file or directory
>
> Caused by commit 9ecbe03ae85b ("pci: infrastructure to add drivers in
> drivers/pci/host").
>
> I have used the arm-soc tree from next-20130418 for today.

Sorry about that, I'll drop the branch that brought in the of_pci
consolidation from our repo.


-Olof
