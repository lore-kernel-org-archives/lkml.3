Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbbARAdi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:33:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbARAdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:33:37 -0500
Date: Sat, 17 Jan 2015 16:22:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Milkovich <amilkovich@gmail.com>
Cc: benjamin.romer@unisys.com, david.kershner@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: virtpci: fixed coding style errors
Message-ID: <20150118002235.GA10241@kroah.com>
References: <1421470690-9534-1-git-send-email-amilkovich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421470690-9534-1-git-send-email-amilkovich@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 08:58:10PM -0800, Andrew Milkovich wrote:
> Fixed coding style errors per checkpatch.pl. Inline comments removed; chanptr
> comment is implied by the first argument being the channel. No parent bus
> comment is already understood by the argument being NULL.
> 
> Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
> ---
>  drivers/staging/unisys/virtpci/virtpci.c | 24 ++++++++----------------
>  1 file changed, 8 insertions(+), 16 deletions(-)

This doesn't apply to my staging-testing branch at all, sorry.

greg k-h
