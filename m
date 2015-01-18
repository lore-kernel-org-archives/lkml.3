Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbbARAQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:16:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbARAQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:16:49 -0500
Date: Sat, 17 Jan 2015 16:07:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Emrys Bayliss <emrys@paradise.net.nz>
Cc: fabio.falzoi84@gmail.com, roxanagabriela10@gmail.com, yejiayily@gmail.com,
        julia.lawall@lip6.fr, himangi774@gmail.com, tapaswenipathak@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rts5208: fix space prohibited before ',' error
 in ms.c
Message-ID: <20150118000742.GA24657@kroah.com>
References: <1420468141-29657-1-git-send-email-emrys@paradise.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420468141-29657-1-git-send-email-emrys@paradise.net.nz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:29:01AM +1100, Emrys Bayliss wrote:
> Fix the checkpatch.pl errors:
> ERROR: space prohibited before that ',' (ctx:WxW)
> 
> Signed-off-by: Emrys Bayliss <emrys@paradise.net.nz>
> ---
>  drivers/staging/rts5208/ms.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Someone else sent this same patch before you did, sorry.

greg k-h
