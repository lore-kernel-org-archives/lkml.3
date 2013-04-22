Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3DVN0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:26:20 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:45790 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3DVN0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:26:19 -0400
Date: Mon, 22 Apr 2013 15:26:06 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: build failure after merge of the arm-soc tree
Message-ID: <20130422152606.5e4fb41a@skate>
In-Reply-To: <CAOesGMhUTyPdNo=yaRqEv+Zhf7ga8e-R0asbnuje_LioWbqsgg@mail.gmail.com>
References: <20130419164636.0d2405ca5fd927f1ba31fe40@canb.auug.org.au>
	<CAOesGMhUTyPdNo=yaRqEv+Zhf7ga8e-R0asbnuje_LioWbqsgg@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Olof Johansson,

On Fri, 19 Apr 2013 07:01:28 -0700, Olof Johansson wrote:

> > After merging the arm-soc tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > powerpc64-linux-ld: cannot find drivers/pci/host/built-in.o: No
> > such file or directory
> >
> > Caused by commit 9ecbe03ae85b ("pci: infrastructure to add drivers
> > in drivers/pci/host").
> >
> > I have used the arm-soc tree from next-20130418 for today.
> 
> Sorry about that, I'll drop the branch that brought in the of_pci
> consolidation from our repo.

The build failure reported here is totally independent of the of_pci
consolidation work. It's caused by the commit pointed in this e-mail,
and it is independent from Andrew Murray's work on of_pci consolidation.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
