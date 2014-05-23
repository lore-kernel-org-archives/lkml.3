Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaEWWZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:25:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaEWWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:25:15 -0400
Date: Sat, 24 May 2014 07:25:13 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: christoph.kohl@t-online.de, michael.hoefler@studium.uni-erlangen.de,
        rupert@rmuch.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Silicom: Bypasslib: Fixed a couple of
 checkpatch.pl warnings
Message-ID: <20140523222513.GA8749@kroah.com>
References: <1400881183-23889-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400881183-23889-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 02:39:43PM -0700, Chaitanya Hazarey wrote:
> Added a blank line after declarations to fix the following warnings issued by checkpatch.pl:
> 
> drivers/staging/silicom/bypasslib/bypass.c:138: WARNING: Missing a blank line after declarations
> drivers/staging/silicom/bypasslib/bypass.c:189: WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Chaitanya Hazarey <c@24.io>
> ---
>  drivers/staging/silicom/bypasslib/bypass.c |    2 ++
>  1 file changed, 2 insertions(+)

This patch doesn't apply cleanly.  Can you please refresh it against my
staging-next branch of staging.git on git.kernel.org and resend?

thanks,

greg k-h
