Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaIBRbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:31:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaIBRbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:31:51 -0400
Date: Tue, 2 Sep 2014 10:31:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sunwxg <sun.wxg@gmail.com>
Cc: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Chi Pham <fempsci@gmail.com>, Oleg Drokin <green@linuxhacker.ru>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: lov_pack: fix coding style issue
Message-ID: <20140902173150.GA21300@kroah.com>
References: <1409586755-805-2-git-send-email-sun.wxg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409586755-805-2-git-send-email-sun.wxg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 11:52:35PM +0800, sunwxg wrote:
> From: Sun Wang <sun.wxg@gmail.com>
> 
> Fix the style error checking by checkpatch.pl
> ERROR: space required after that ','
> 
> Signed-off-by: Sun Wang <sun.wxg@gmail.com>
> 
> ---
>  drivers/staging/lustre/lustre/lov/lov_pack.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Someone already submitted this fix before you did, sorry.

greg k-h
