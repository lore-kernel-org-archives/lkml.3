Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3LCCgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:36:52 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63906 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3LCCgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:36:49 -0500
Date: Mon, 2 Dec 2013 18:36:46 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'David Miller'" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 20/39] net: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131202183646.459564a9@nehalam.linuxnetplumber.net>
In-Reply-To: <002901ceefb4$f1191e30$d34b5a90$%han@samsung.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
	<002901ceefb4$f1191e30$d34b5a90$%han@samsung.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Dec 2013 08:19:25 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Perhaps a little more explanation why it is not preferred.
Not everyone tracks LKML or the PCI list.
