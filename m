Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054Ab3BTBot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:44:49 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59613 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab3BTBos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:44:48 -0500
Date: Tue, 19 Feb 2013 17:45:12 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
Message-ID: <20130220014512.GC31018@kroah.com>
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 05:53:44PM +0200, Kirill A. Shutemov wrote:
> From: Andy Ross <andy.ross@windriver.com>
> 
> When vt.init_hide is set, suppress output on newly created consoles until
> an affirmative switched to that console.  This prevents boot output from
> displaying (and clobbering splash screens, etc...) without disabling the
> console entirely.

What's wrong with the 'quiet' option we have?  And you forgot to
document this.

greg k-h
