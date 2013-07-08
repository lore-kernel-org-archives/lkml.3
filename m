Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3GHQmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:42:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab3GHQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:42:51 -0400
Date: Mon, 8 Jul 2013 09:42:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: Re: [PATCH 1/4] lkdtm: fix stack protector trigger
Message-ID: <20130708164250.GA12670@kroah.com>
References: <1371926227-2609-1-git-send-email-keescook@chromium.org>
 <1371926227-2609-2-git-send-email-keescook@chromium.org>
 <CAGXu5jKrW4t0HxBiinYTQs9eun_Z+bkNCjKgM_RYaL6Vz1PsoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKrW4t0HxBiinYTQs9eun_Z+bkNCjKgM_RYaL6Vz1PsoA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 06:09:50AM -0700, Kees Cook wrote:
> Hi,
> 
> I'd like to get this series added to lkdtm. Can someone take a moment
> to review or ack them?

I don't see these in my queue at all, did you copy me the first time
around on them?

Care to resend them?  Everything is on hold until 3.11-rc1 is out for
new stuff like this, so you'll have to wait until then at the earliest.

thanks,

greg k-h
