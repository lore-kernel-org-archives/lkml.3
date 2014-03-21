Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbaCUICM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 04:02:12 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:40881 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaCUICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 04:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <daae779db6ec1b3177c88024216f37d88fd59cd9.1395350113.git.richardcochran@gmail.com>
References: <cover.1395350105.git.richardcochran@gmail.com>
	<daae779db6ec1b3177c88024216f37d88fd59cd9.1395350113.git.richardcochran@gmail.com>
Date: Fri, 21 Mar 2014 01:02:06 -0700
X-Google-Sender-Auth: 269z3ngAall67UDIFaCZJtxUrpc
Message-ID: <CAL3LdT6aZYiyebbN_e0LkPP8jQpO=5d=OCb9i2cKcdej6jPYcA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/9] ptp: drivers: set the number of
 programmable pins.
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Christian Riesch <christian.riesch@omicron.at>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Stefan_S=C3=B8rensen?= <stefan.sorensen@spectralink.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 2:21 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> This patch updates the many PTP Hardware Clock drivers with the
> newly introduced field that advertises the number of programmable
> pins. Some of these devices do have programmable pins, but the
> implementation will have to wait for follow on patches.
>
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/net/ethernet/adi/bfin_mac.c              |    1 +
>  drivers/net/ethernet/broadcom/tg3.c              |    1 +
>  drivers/net/ethernet/freescale/fec_ptp.c         |    1 +
>  drivers/net/ethernet/freescale/gianfar_ptp.c     |    1 +
>  drivers/net/ethernet/intel/e1000e/ptp.c          |    1 +
>  drivers/net/ethernet/mellanox/mlx4/en_clock.c    |    1 +
>  drivers/net/ethernet/sfc/ptp.c                   |    1 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c |    1 +
>  drivers/net/ethernet/ti/cpts.c                   |    1 +
>  drivers/net/ethernet/tile/tilegx.c               |    1 +
>  drivers/ptp/ptp_ixp46x.c                         |    1 +
>  drivers/ptp/ptp_pch.c                            |    1 +
>  12 files changed, 12 insertions(+)
>

For the e1000e change...

Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
