Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab3K3THt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 14:07:49 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47552 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3K3THq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 14:07:46 -0500
MIME-Version: 1.0
In-Reply-To: <1385227995-3956-1-git-send-email-alchark@gmail.com>
References: <1385227995-3956-1-git-send-email-alchark@gmail.com>
Date: Sat, 30 Nov 2013 23:07:44 +0400
Message-ID: <CABjd4Yx9bkbLaCVk01u0iPg0V5GJLBq3xbaLU0Ay17e9rEuCNg@mail.gmail.com>
Subject: Re: [PATCH 0/3] net: via-rhine: add support for on-chip Rhine controllers
From: Alexey Charkov <alchark@gmail.com>
To: Roger Luethi <rl@hellgate.ch>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Cc: Alexey Charkov <alchark@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/23, Alexey Charkov <alchark@gmail.com>:
> This series introduces platform bus (OpenFirmware) binding for via-rhine,
> as used in various ARM-based Systems-on-Chip by VIA/WonderMedia.
>
> This has been tested on a WM8950-based VIA APC Rock development board
>
> Alexey Charkov (3):
>   net: via-rhine: switch to generic DMA functions
>   net: via-rhine: reduce usage of the PCI-specific struct
>   net: via-rhine: add OF bus binding
>
>  .../devicetree/bindings/net/via-rhine.txt          |  18 +
>  drivers/net/ethernet/via/Kconfig                   |   2 +-
>  drivers/net/ethernet/via/via-rhine.c               | 403
> ++++++++++++---------
>  3 files changed, 260 insertions(+), 163 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/via-rhine.txt
>
> --
> 1.8.1.5
>

Dear all,

There hasn't been any feedback on this so far (which is
understandable, given that it came pretty early in the release cycle).

Is there any chance to get this reviewed, to be eventually included in
net-next for 3.14? That would be highly appreciated.

Thanks a lot,
Alexey
