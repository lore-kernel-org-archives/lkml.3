Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3CEVxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:53:47 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56024 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab3CEVxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:53:45 -0500
Date: Wed, 6 Mar 2013 05:54:08 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER
 configurations
Message-ID: <20130305215408.GD10965@kroah.com>
References: <1362511248.16460.113.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362511248.16460.113.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 08:20:48PM +0100, Paul Bolle wrote:
> Fix obvious typo introduced in commit
> e121aefa7d9f10eee5cf26ed47129237a05d940b ("remoteproc: fix missing
> CONFIG_FW_LOADER configurations").
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
> 
> 1) The REMOTEPROC Kconfig entry has been using the useless FW_CONFIG
> select statement for a few releases now. Does it really need to select
> FW_LOADER?
> 
>  drivers/remoteproc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
