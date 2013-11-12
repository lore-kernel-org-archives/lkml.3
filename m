Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3KLHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:33:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3KLHce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:32:34 -0500
Date: Mon, 11 Nov 2013 16:27:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Aldo Iljazi <mail@aldo.io>
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: ft1000: ft1000_download: fixed coding style
 issues
Message-ID: <20131112002709.GA7709@kroah.com>
References: <1384091060-29915-1-git-send-email-mail@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384091060-29915-1-git-send-email-mail@aldo.io>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 03:44:20PM +0200, Aldo Iljazi wrote:
> Fixed the following coding style issues:

Note that I added the filename to the Subject:, please do so in the
future to make it easier to see what exactly you are changing.

> 
> Lines 84-91,99-106,275,514: Replaced spaces at the start of the lines
> with tabs.
> 
> Lines 205,271: Inserted spaces after the commas.
> Lines 275,1060,1065: Indented the code with tabs instead of spaces.

That's funny, as the rest of those functions need to be indented using
tabs instead of spaces.

But I'll take this for now, no worries, thanks.

greg k-h
