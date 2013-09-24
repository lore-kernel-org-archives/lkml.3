Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750778Ab3IXEZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:25:04 -0400
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:42784 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IXEZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:25:01 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 08/12] bluetooth: Remove extern from function prototypes
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <e9994a2b839277a9237364b59e655060f1fcb957.1379961014.git.joe@perches.com>
Date: Tue, 24 Sep 2013 06:24:54 +0200
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D711EDE5-05F9-47F3-9A57-AFCD065D900D@holtmann.org>
References: <445209f8885ccd8234fa787c30d63e63fc7917d7.1379961014.git.joe@perches.com> <e9994a2b839277a9237364b59e655060f1fcb957.1379961014.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> include/net/bluetooth/bluetooth.h | 16 ++++++++--------
> include/net/bluetooth/hci_core.h  | 23 +++++++++++------------
> include/net/bluetooth/rfcomm.h    |  4 ++--
> 3 files changed, 21 insertions(+), 22 deletions(-)

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel

