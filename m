Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933752AbaEFCZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:25:50 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49264 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933639AbaEFCZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:25:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] rfcomm: Convert spinlocks into mutexes
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140429183834.GA6076@fmn.suse.cz>
Date: Mon, 5 May 2014 19:25:50 -0700
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Cho <acho@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <7304B0EB-403B-401E-8823-CBB1012C4229@holtmann.org>
References: <20140429183834.GA6076@fmn.suse.cz>
To: Libor Pechacek <lpechacek@suse.cz>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libor,

> Enabling CONFIG_DEBUG_ATOMIC_SLEEP has shown that some rfcomm functions
> acquiring spinlocks call sleeping locks further in the chain.  Converting
> the offending spinlocks into mutexes makes sleeping safe.
> 
> Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
> ---
> include/net/bluetooth/rfcomm.h |  6 +++---
> net/bluetooth/rfcomm/core.c    |  2 +-
> net/bluetooth/rfcomm/tty.c     | 20 ++++++++++----------
> 3 files changed, 14 insertions(+), 14 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

