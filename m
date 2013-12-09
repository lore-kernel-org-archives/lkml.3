Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab3LIIYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:24:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3LIIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:24:08 -0500
Date: Sun, 8 Dec 2013 17:30:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Preetam D'Souza" <preetamjdsouza@gmail.com>
Cc: devel@driverdev.osuosl.org, swetland@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: fix parantheses coding style issue in
 alarm-dev.c
Message-ID: <20131209013019.GA18048@kroah.com>
References: <1386455752-17600-1-git-send-email-preetamjdsouza@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386455752-17600-1-git-send-email-preetamjdsouza@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 02:35:52PM -0800, Preetam D'Souza wrote:
> This patch fixes an unecessary return statement parantheses error
> found in alarm-dev.c by the checkpatch.pl tool -- alarm-dev.c now has
> no more errors/warnings!
> 
> Signed-off-by: Preetam D'Souza <preetamjdsouza@gmail.com>
> ---
>  drivers/staging/android/alarm-dev.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This was already fixed a while ago, what tree are you working against?

sorry, I can't apply this again.

greg k-h
