Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3FDUKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 16:10:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3FDUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 16:10:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] net: emaclite: Use platform resource table
Date: Tue, 4 Jun 2013 22:10:05 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
References: <6ece0a9ee777b987ca777a338cc146ed67897529.1370340196.git.michal.simek@xilinx.com>
In-Reply-To: <6ece0a9ee777b987ca777a338cc146ed67897529.1370340196.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306042210.05844.arnd@arndb.de>
X-Provags-ID: V02:K0:Silliz5+5NN963EOgh/Jk56hvdebbraY+7uOnXy9asf
 e9RxUkBndGoer+aj4ydx+OnCE+9Tui+Io98YQHWyIW2ZGVaua/
 6ABzpk/gsytDTSOWT+R/KOCOcuwUPKnepww8ukECNAetnE02G+
 3umBB/vZ8nQJsRnmh7XyxNQWZ4LhpyGyXfRjyPVZg6RwLfVxDd
 k7MbJ9A5Z0r80DkEwJ8KBQJi9cWsWvhJIaxEyT/7rUR14Oy21B
 TXhVXS4l2ko0WK+i3VvsolHVFHlyzncAvxPELWehfQElKSeQJM
 J/iY4LuFHWPWBzwCs8ENTSp7DvsEQLNcb1DD82B/U+XVZZBV+U
 rN2vOyVi6Gkz2DstVtWA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013, Michal Simek wrote:
>   Read data directly from platform recource table
> and do not use of_irq_to_resource().
> Also use devm_request_and_ioremap() for probe
> functions simplification.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> Based on my discussion with Arnd
> "[PATCH] net: emaclite: include linux/of_irq.h"
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
