Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3L3SxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:53:24 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50799 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab3L3SxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:53:22 -0500
MIME-Version: 1.0
X-Originating-IP: [89.2.236.51]
In-Reply-To: <mj+md-20131215.110132.29802.nikam@ucw.cz>
References: <1378302428-19758-1-git-send-email-teg@jklm.no>
 <mj+md-20130904.134928.12262.nikam@ucw.cz> <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
 <mj+md-20131110.114139.9646.albireo@ucw.cz> <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
 <mj+md-20131215.091609.28546.nikam@ucw.cz> <CAPXgP10+1WtX8_xN+QSHvKws01hbKhP3FN95sXk9EtezdSPtqg@mail.gmail.com>
 <mj+md-20131215.110132.29802.nikam@ucw.cz>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 30 Dec 2013 19:53:01 +0100
Message-ID: <CAG-2HqUGcBB1-YUvLZpqm1EZ69OSksa+iGcCEqVWxYsehDqx8Q@mail.gmail.com>
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb support
To: Martin Mares <mj@ucw.cz>
Cc: Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Sun, Dec 15, 2013 at 12:33 PM, Martin Mares <mj@ucw.cz> wrote:
> I see that a mechanism for fast lookup of hardware identification data
> is needed. However, why should such a mechanism depend on udev, systemd,
> or Linux in general?
>
> What I would really like to have is a universal library for HW lookup,
> independent of anything else and widely portable. All the hardware data
> would be provided by other packages -- pci.ids, usb.ids, kernel modules,
> etc. -- and compiled to a binary format available for instant queries.

I'd like to reach an agreement on this patch, so I'll resend it with
the changes we agreed on so far. Please let me know if further changes
are needed.

If I understand correctly, you are ok with the functionality hwdb
provides, but would have preferred an OS-agnostic solution. However,
as no such solution currently exist, and the patch adding hwdb support
is pretty minimal and self-contained, would you be happy taking that
for now, and rather revisit the topic if and when a generic solution
appears?

FWIW, I made the analogous change to lsusb some time ago [0], so would
be cool to get this all done.

Cheers,

Tom

[0]: <https://github.com/gregkh/usbutils/commit/c6282a7a0e20fbb9c56837f055843635a43ba8b4>
