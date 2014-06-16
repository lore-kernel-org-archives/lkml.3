Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaFPO1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:27:24 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:44501 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaFPO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:27:23 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <8B2F6FFD0BD1E448853114367400A37306FCD2E22A@BLRX7MCDC203.AMER.DELL.COM>
References: <8B2F6FFD0BD1E448853114367400A37306FCD2E023@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqUDQ3e-cq4y3zgehz6J8E6LsTCUfqvMEqPEqG7aBmEeRg@mail.gmail.com>
 <8B2F6FFD0BD1E448853114367400A37306FCD2E02A@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqXBOfZTGi-S=AzjGYDyGWkh0ijz73_pUUtmFdmQkgxWVQ@mail.gmail.com> <8B2F6FFD0BD1E448853114367400A37306FCD2E22A@BLRX7MCDC203.AMER.DELL.COM>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 16 Jun 2014 16:27:02 +0200
Message-ID: <CAG-2HqUwdsW_EbccAs5jLV81XwkiA6BaSg_6A5hsKtruaWv94A@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: allow disabling of udev as firmware loader
To: b_b_singh <B_B_Singh@dell.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>,
        matt_domsch <Matt_Domsch@dell.com>,
        srinivas_g_gowda <Srinivas_G_Gowda@dell.com>,
        stuart_hayes <Stuart_Hayes@dell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 5:13 PM,  <B_B_Singh@dell.com> wrote:
> I see contradiction of drivers/base/Kconfig here i.e, If I configure DELL_RBU=y I cannot configure FW_LOADER_USER_HELPER=n.
> with this patch https://lkml.org/lkml/2014/6/4/327 i cannot have FW_LOADER_USER_HELPER=n & DELL_RBU=y at the same time.
> I'm using the latest stable upstream kernel-3.14.5.
>
> Symbol: FW_LOADER_USER_HELPER [=y]
> Type     : boolean
> Defined at drivers/base/Kconfig:146
> Selected by: FW_LOADER_USER_HELPER_FALLBACK [=n] && FW_LOADER [=y] || DELL_RBU [=y] && X86 [=y]

Yes, with that version of the patch you should instead try with
FW_LOADER_USER_HELPER_FALLBACK=n (the options were renamed). Does that
work for you?

Cheers,

Tom
