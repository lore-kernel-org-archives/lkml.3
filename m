Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3DHEdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:33:39 -0400
Received: from ozlabs.org ([203.10.76.45]:50696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab3DHEdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:33:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@linuxfoundation.org>,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, Philip Kranz <philip.kranz@googlemail.com>
Subject: Re: [PATCH] Make information about modules available to kgdb.
In-Reply-To: <20130406165733.GA29794@kroah.com>
References: <1365253255-14154-1-git-send-email-sisewank@cip.cs.fau.de> <20130406165733.GA29794@kroah.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Apr 2013 13:45:51 +0930
Message-ID: <8761zxbqtk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:
> On Sat, Apr 06, 2013 at 03:00:55PM +0200, Sebastian Wankerl wrote:
>> From: Philip Kranz <philip.kranz@googlemail.com>
>> 
>> To be able to properly debug kernel modules kgbd needs to know all SHF_ALLOC
>> sections of the module. This patch add an array of those sections to struct
>> module. One cannot use sysfs since it does not contain all sections needed.
>
> Why not just add those sections to sysfs so that everyone can see them?

That's what we're going to do, but it breaks PARISC.  So we're debating
the exact method with James.

Cheers,
Rusty.
