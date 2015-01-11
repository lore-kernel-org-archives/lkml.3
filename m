Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbbAKVhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:37:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbbAKVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:37:38 -0500
Date: Sun, 11 Jan 2015 13:37:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Gustavo A. R. Silva" <silvagustavosilva@gmail.com>
Cc: jak@jak-linux.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH 3/3] Staging: nvec: Fixed a typo
Message-ID: <20150111213737.GA20983@kroah.com>
References: <1421010735-28799-1-git-send-email-silvagustavosilva@gmail.com>
 <20150111212731.GA3937@kroah.com>
 <CANE5pd=DH=5U_O37Q0qBc+1hTrc8f=H0vhMuEBHCW5c0ek8+EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANE5pd=DH=5U_O37Q0qBc+1hTrc8f=H0vhMuEBHCW5c0ek8+EA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 03:33:01PM -0600, Gustavo A. R. Silva wrote:
> 
> 
> 2015-01-11 15:27 GMT-06:00 Greg KH <gregkh@linuxfoundation.org>:
> 
>     On Sun, Jan 11, 2015 at 03:12:15PM -0600, Gustavo A. R. Silva wrote:
>     > Fixed a typo in nvec.c file
>     >
>     > Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>     > ---
>     >  drivers/staging/nvec/nvec.c | 2 +-
>     >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>     Where are patches 1/3 and 2/3?
> 
> 
> There are no such patches.
> I don't know why it is generating such label instead of just [PATCH].

How did you generate the patch?

> I updated my main Makefile and generated a local patch, could this be the
> reason?

I don't know.

> Should I modified that label to be just [PATCH]? 

If you are sending 2 patches, they should be in order, with numbering.

greg k-h
