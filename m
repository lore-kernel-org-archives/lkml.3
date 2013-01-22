Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AVUeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:34:46 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65461 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3AVUeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:34:44 -0500
Date: Tue, 22 Jan 2013 12:34:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/20] net: remove CONFIG_EXPERIMENTAL
Message-ID: <20130122203441.GA2580@kroah.com>
References: <1358879444-25834-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358879444-25834-1-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:30:24AM -0800, Kees Cook wrote:
> Here's what's left of the "remove experimental"[1] tree, all for netdev.
> 
> What would be the preference for taking these patches for linux-next?
> Should they go via the netdev tree, or should I ask Greg KH to take them
> via driver-core?

All now applied, thanks.

greg k-h
