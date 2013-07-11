Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3GKVWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 17:22:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3GKVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 17:22:06 -0400
Date: Thu, 11 Jul 2013 14:22:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, axboe@kernel.dk, oakad@yahoo.com, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memstick: add support for legacy memorysticks
Message-Id: <20130711142204.6c1fc4c260676da6cad93be7@linux-foundation.org>
In-Reply-To: <1373502517.14147.0.camel@maxim-laptop>
References: <1373292716.32554.5.camel@maxim-laptop>
	<1373316896-6045-1-git-send-email-maximlevitsky@gmail.com>
	<1373316896-6045-2-git-send-email-maximlevitsky@gmail.com>
	<1373502517.14147.0.camel@maxim-laptop>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013 03:28:37 +0300 Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Mon, 2013-07-08 at 23:54 +0300, Maxim Levitsky wrote: 
> > Based partially on MS standard spec quotes from Alex Dubov.
> > 
> > As any code that works with user data this driver isn't
> > recommended to use to write cards that contain valuable data.
> > 
> > It tries its best though to avoid data corruption
> > and possible damage to the card.
> > 
> > Tested on MS DUO 64 MB card on Ricoh R592 card reader.
> > 

(top-posting repaired.  Please don't do that).

> Any update?

You sent a large patch in the middle of the 3.11 merge window, when
nobody is looking at large new patches.

I have it saved away for consideration after -rc1.
