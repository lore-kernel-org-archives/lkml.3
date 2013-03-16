Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3CPWMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:12:52 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:37241 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3CPWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:12:50 -0400
Date: Sat, 16 Mar 2013 15:13:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: stop checking for CONFIG_EXPERIMENTAL
Message-ID: <20130316221358.GB3702@kroah.com>
References: <1363469435.1335.137.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363469435.1335.137.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 10:30:35PM +0100, Paul Bolle wrote:
> 1) A lot of defconfigs still have CONFIG_EXPERIMENTAL in them. How
> should that be cleaned up?

Just ignore it, when ever those defconfigs ever get used, or updated, it
will fall out automatically.

thanks,

greg k-h
