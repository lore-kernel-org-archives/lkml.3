Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaHJML2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaHJMLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:16 -0400
Date: Sat, 9 Aug 2014 21:23:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Hans Wennborg <hans@hanshq.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/19] staging: rtl8192ee: fix %d confusingly prefixed
 with 0x in format strings
Message-ID: <20140810042358.GA15249@kroah.com>
References: <1407111658-15236-1-git-send-email-hans@hanshq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407111658-15236-1-git-send-email-hans@hanshq.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 05:20:58PM -0700, Hans Wennborg wrote:
> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/staging/rtl8192ee/pci.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This patch fails to apply to my tree :(

