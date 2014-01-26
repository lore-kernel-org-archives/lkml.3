Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaAZPvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 10:51:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaAZPvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 10:51:23 -0500
Date: Sun, 26 Jan 2014 16:51:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out if the name buffer is too short
Message-ID: <20140126155141.GA12249@redhat.com>
References: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com> <20140124161922.GA14195@redhat.com> <20140126153737.GA8184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140126153737.GA8184@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Oleg Nesterov wrote:
>
> Heh. Not sure what I was thinking about, but this looks obviously wrong
> when I re-read my email. This will add the extra "/" at the end, unless
> IS_ROOT().

And this motivated me to try to actually read __dentry_path().

Al, Denys, unless I am totally confused the "restart" logic is very broken.
We can't simply restart because the main loop changes dentry?

Oleg.

