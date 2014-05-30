Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaE3E3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:29:32 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:48687 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaE3E31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:29:27 -0400
MIME-Version: 1.0
In-Reply-To: <1400970182-20196-1-git-send-email-chase.southwood@gmail.com>
References: <1400970182-20196-1-git-send-email-chase.southwood@gmail.com>
Date: Thu, 29 May 2014 23:29:27 -0500
Message-ID: <CA+jnaaV4gE+1eN8TR=rRT4nekiGDOzXw9PqTTsPAkA+qrAJpCg@mail.gmail.com>
Subject: Re: [PATCH 0/3] staging: comedi: addi_apci_1564: prepare for adding
 Change-of-State interrupt support
From: Chase Southwood <chase.southwood@gmail.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>, hsweeten@visionengravers.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chase Southwood <chase.southwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sat, May 24, 2014 at 5:23 PM, Chase Southwood
<chase.southwood@gmail.com> wrote:
> This patchset adds the required subdevice for supporting DI COS interrupts,
> as well as introducing a driver-specific private data struct that will
> make the COS interrupt operations much more straightforward and clean.
>
> Chase Southwood (3):
>   staging: comedi: addi_apci_1564: add a subdevice for Change-of-State
>     interrupt support
>   staging: comedi: addi_apci_1564: remove send_sig() use
>   staging: comedi: addi_apci_1564: introduce apci1564_private struct
>
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 200 ++++++++++-----------
>  drivers/staging/comedi/drivers/addi_apci_1564.c    |  54 +++---
>  2 files changed, 126 insertions(+), 128 deletions(-)

Please ignore this patchset completely, I am sending one out
momentarily that serves as its replacement.

Thanks,
Chase
