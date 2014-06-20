Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966390AbaFSX5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:57:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965771AbaFSX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:57:24 -0400
Date: Thu, 19 Jun 2014 17:01:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Wood <tommyandrena@gmail.com>
Cc: dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] staging: ft1000: ft1000-usb: ft1000_debug.c:
 Misc. fixes.
Message-ID: <20140620000124.GA29804@kroah.com>
References: <20140602103056.GY15585@mwanda>
 <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
 <1402110138-13713-6-git-send-email-tommyandrena@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402110138-13713-6-git-send-email-tommyandrena@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 08:02:18PM -0700, Thomas Wood wrote:
> Remove initialization of static value.
> Invert the empty if statement's test to replace the else statement.
> Remove parentheses from a return statement.
> Fix some code indentation.
> 
> Signed-off-by: Thomas Wood <tommyandrena@gmail.com>
> ---
> 
> I'm pretty sure that the indentation was caused by a mistake by me earlier on in the patch set, so I'm fixing it now.

As Dan says, please fix this in the original patch.

Can you please fix this up and resend the whole series?

thanks,

greg k-h
