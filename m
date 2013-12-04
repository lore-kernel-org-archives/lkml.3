Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab3LDCDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:03:51 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39334 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3LDCDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:03:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAL-B5D3t=K-m5Y=Vvgv=SnrOLni8rAJC5eW8J1CEBsgafjTemA@mail.gmail.com>
References: <1385851238-21085-1-git-send-email-yinghai@kernel.org>
	<CAL-B5D3t=K-m5Y=Vvgv=SnrOLni8rAJC5eW8J1CEBsgafjTemA@mail.gmail.com>
Date: Tue, 3 Dec 2013 18:03:49 -0800
X-Google-Sender-Auth: schMZnLoBSsrDYPDTRCMU7xuyJA
Message-ID: <CAE9FiQVxCykW+LD=UXRbkQvwniBK9-7BdjufjAwRu2E_pPtN5w@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] PCI: Double removing fix and allocate 64bit mmio pref
From: Yinghai Lu <yinghai@kernel.org>
To: Myron Stowe <myron.stowe@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 1, 2013 at 9:05 AM, Myron Stowe <myron.stowe@gmail.com> wrote:
> Would you please consider *not* bundling unrelated, or at least
> non-dependent, patches together in one series.  As a distrobution
> subsystem maintainer, this type of bundling really complicates trying
> to identify and isolate key material for bringing in.  It also makes
> trying to identify the core content for key fixes, which can occur
> many months or years later, significantly more difficult when they
> were buried within a series with other unrelated content

ok.

Will resend them in three patchset.

Thanks

Yinghai
