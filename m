Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbbAMF73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:59:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbAMF71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:59:27 -0500
Date: Mon, 12 Jan 2015 19:39:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Adithya K <linux.challenge1@gmail.com>
Cc: forest@alittletooquiet.net, tvboxspy@gmail.com, gclement@baobob.org,
        joe@perches.com, guido@vanguardiasur.com.ar,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Adithya Krishnamurthy <linux.challenge@gmail.com>
Subject: Re: [PATCH 1/1] [PATCH] Staging:vt6655: sparse warning fix
Message-ID: <20150113033939.GA10354@kroah.com>
References: <1418138911-20708-1-git-send-email-linux.challenge1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418138911-20708-1-git-send-email-linux.challenge1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 08:58:31PM +0530, Adithya K wrote:
> From: Adithya Krishnamurthy <linux.challenge@gmail.com>
> 
> Fixed sparse warning(symbol was not declared. Should it be static) fix.
> 
> Signed-off-by: Adithya Krishnamurthy <linux.challenge1@gmail.com>
> ---
> ---
>  drivers/staging/vt6655/device_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Does not apply to my tree :(
