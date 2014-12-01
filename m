Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaLALZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:25:51 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:28489 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaLALZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:25:48 -0500
Date: Mon, 1 Dec 2014 16:58:05 +0530
From: Hariprasad S <hariprasad@chelsio.com>
To: <ben@decadent.org.uk>, <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
Message-ID: <20141201112803.GA17578@hariprasad-pc>
References: <20141017183329.GA5275@hariprasad-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141017183329.GA5275@hariprasad-pc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.193.190.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 00:03:29 +0530, Hariprasad S wrote:
> Hi,
> 
> Can you please pull from the following URL?
> 
> The following changes since commit 0e5f63771d0df6d7859f7c4100a74d737c62ac88:
>     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> 
> Thanks
> 
>   linux-firmware: Add firmware patch for Intel Bluetooth 7265 ROM-spin(D0) (2014-10-09 11:59:44 -0400)
> 
> are available in the git repository at:
> 
>   git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
> 
> for you to fetch changes up to 7831ff2b2a129e8a70f4c7b7a1d0c8ad9e241ffe:
> 
>   cxgb4: Update firmware to revision 1.12.25.0 (2014-10-17 11:13:37 -0700)
> 
> ----------------------------------------------------------------
> Hariprasad Shenai (1):
>       cxgb4: Update firmware to revision 1.12.25.0
> 
>  WHENCE                   |   8 ++++----
>  cxgb4/t4fw-1.11.27.0.bin | Bin 512512 -> 0 bytes
>  cxgb4/t4fw-1.12.25.0.bin | Bin 0 -> 518656 bytes
>  cxgb4/t4fw.bin           |   2 +-
>  cxgb4/t5fw-1.11.27.0.bin | Bin 513024 -> 0 bytes
>  cxgb4/t5fw-1.12.25.0.bin | Bin 0 -> 521216 bytes
>  cxgb4/t5fw.bin           |   2 +-
>  7 files changed, 6 insertions(+), 6 deletions(-)
>  delete mode 100644 cxgb4/t4fw-1.11.27.0.bin
>  create mode 100644 cxgb4/t4fw-1.12.25.0.bin
>  delete mode 100644 cxgb4/t5fw-1.11.27.0.bin
>  create mode 100644 cxgb4/t5fw-1.12.25.0.bin

Hi,

My bad. We had a power-surge issue yesterday in our office, due to which the git server was down.
We apologies for the inconvenience caused. 

Can you please pull it.

Thanks,
Hari
