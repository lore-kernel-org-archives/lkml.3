Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbaCSA4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:56:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbaCSA4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:56:14 -0400
Date: Tue, 18 Mar 2014 17:58:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Ken Cox <jkc@redhat.com>, devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: use kzalloc instead of kmalloc/memset 0
Message-ID: <20140319005816.GA18725@kroah.com>
References: <4376102.svyTz8ADVT@daeseok-laptop.cloud.net>
 <20140317214145.GA29105@kroah.com>
 <CAHb8M2BwuCJEGueP+-cOatynS5QcSrJMeei_D=0-GdKGxi5N-Q@mail.gmail.com>
 <53284382.7080509@redhat.com>
 <CAHb8M2A1J242RZoc49zu47HW5c0iVsJAXiu7KeBL8uFk2TJkGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2A1J242RZoc49zu47HW5c0iVsJAXiu7KeBL8uFk2TJkGA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Wed, Mar 19, 2014 at 09:09:59AM +0900, DaeSeok Youn wrote:
> Hi, Ken
> Thanks for review.
> 
> But I have a question,  I wan to know why tracing buffer
> status(Malloc_FailuresAlloc, Malloc_BytesInUse...) for
> info_proc_read_helper() are needed.
> If it doesn't need, whole tracing stuff for memory can be removed.

Yes, that is something that also should be removed.


greg k-h
