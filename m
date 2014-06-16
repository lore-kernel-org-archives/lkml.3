Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaFPO23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:28:29 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:59874 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFPO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:28:28 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <8B2F6FFD0BD1E448853114367400A37306FCDFE8A7@BLRX7MCDC203.AMER.DELL.COM>
References: <8B2F6FFD0BD1E448853114367400A37306FCD2E023@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqUDQ3e-cq4y3zgehz6J8E6LsTCUfqvMEqPEqG7aBmEeRg@mail.gmail.com>
 <8B2F6FFD0BD1E448853114367400A37306FCD2E02A@BLRX7MCDC203.AMER.DELL.COM>
 <CAG-2HqXBOfZTGi-S=AzjGYDyGWkh0ijz73_pUUtmFdmQkgxWVQ@mail.gmail.com> <8B2F6FFD0BD1E448853114367400A37306FCDFE8A7@BLRX7MCDC203.AMER.DELL.COM>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 16 Jun 2014 16:28:07 +0200
Message-ID: <CAG-2HqUDsda5sk7Mp5idKG7Wig+kawgZEpKV5dSRaWe1sgPmmw@mail.gmail.com>
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

On Mon, Jun 16, 2014 at 4:08 PM,  <B_B_Singh@dell.com> wrote:
> Today I have tried with 3.15 the behavior is same as before.

None of these patches were in 3.15, so that should behave as before.

Cheers,

Tom
