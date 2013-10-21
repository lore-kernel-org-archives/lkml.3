Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab3JUDub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 23:50:31 -0400
Received: from ozlabs.org ([203.10.76.45]:40286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab3JUDu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 23:50:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: module: Documentation/module-signing.txt?
In-Reply-To: <1382086956.16689.6.camel@x220.thuisdomein>
References: <1382086956.16689.6.camel@x220.thuisdomein>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 21 Oct 2013 11:32:42 +1030
Message-ID: <87a9i3mo5p.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle <pebolle@tiscali.nl> writes:
> Rusty,
>
> Since v3.7 there's a link to Documentation/module-signing.txt in
> init/Kconfig. It was added by your commit 106a4ee258d1 ("module:
> signature checking hook"). It seems that this file was never added to
> the tree. Is it perhaps queued somewhere?

Well spotted.  David?

Thanks,
Rusty.
