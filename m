Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3ELVkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:40:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34672 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3ELVku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:40:50 -0400
Message-ID: <1368394787.9190.0.camel@zurbaran>
Subject: Re: [PATCH] NFC: remove commented out Makefile line
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 12 May 2013 23:39:47 +0200
In-Reply-To: <1368393684.1350.16.camel@x61.thuisdomein>
References: <1368393684.1350.16.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, 2013-05-12 at 23:21 +0200, Paul Bolle wrote:
> The Kconfig symbol NFC_LLCP was removed in commit 30cc458765 ("NFC: Move
> LLCP code to the NFC top level diirectory"). But the reference to its
> macro in this Makefile was only commented out. Remove it now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  net/nfc/Makefile | 1 -
>  1 file changed, 1 deletion(-)
Applied to my nfc-fixes tree, thanks.

Cheers,
Samuel.

