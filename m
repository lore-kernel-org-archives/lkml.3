Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935194Ab3DJCRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:17:19 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59814 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3DJCRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:17:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7DhyVwNng=uBR=YMC3ZMFUtV-MDuukjMMGFxMmgHZR=w@mail.gmail.com>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
	<1363217302-14383-27-git-send-email-yinghai@kernel.org>
	<CAErSpo7DhyVwNng=uBR=YMC3ZMFUtV-MDuukjMMGFxMmgHZR=w@mail.gmail.com>
Date: Tue, 9 Apr 2013 19:17:16 -0700
X-Google-Sender-Auth: EN5_pnF81sP3xJfE_uD5_MGPgzs
Message-ID: <CAE9FiQXZYrnx1n6Oh33k7DYWPujy9XSxE20JFGAYohcE_EvVhQ@mail.gmail.com>
Subject: Re: [PATCH v3 26/27] PCI: Make quirk_io_region to use addon_res
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 2:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> This patch has two changes that need to be separated:
>
>   1) Refactoring quirk_io_region() so the pci_read_config_word() is
> done by quirk_io_region() rather than the caller.
>   2) Whatever pci_dev resource changes we end up making.
>
> I think part 1 can be done at any time and is probably not controversial.

ok, will put that separated one to be first one in the next reversion
of patchset.

Thanks

Yinghai
