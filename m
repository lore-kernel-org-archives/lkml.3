Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3DKUYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:24:38 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:45992 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3DKUYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:24:36 -0400
Date: Thu, 11 Apr 2013 13:24:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: tty: serial: tegra: use devm_ioremap_resource()
Message-ID: <20130411202434.GA31078@kroah.com>
References: <1365710337-12251-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365710337-12251-1-git-send-email-silviupopescu1990@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:58:57PM +0300, Silviu-Mihai Popescu wrote:
> Convert  use of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> This was found with coccinelle.

And it's already in my tree, please always work off of linux-next to
avoid doing the same thing that others have done.

sorry,

greg k-h
