Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaA0Rk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:40:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbaA0Rk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:40:26 -0500
Date: Mon, 27 Jan 2014 18:40:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: error out if the name buffer is too short
Message-ID: <20140127174042.GC32450@redhat.com>
References: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com> <20140124161922.GA14195@redhat.com> <20140126153737.GA8184@redhat.com> <20140126155141.GA12249@redhat.com> <20140126163536.GA21320@redhat.com> <20140126174134.GZ10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140126174134.GZ10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Al Viro wrote:
>
> ... and already fixed.  Said that, the point about restarts is definitely
> true.  See vfs.git#for-linus - it should propagate in a few

Yes, http://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/commit/?h=for-linus&id=f6500801522c61782d4990fa1ad96154cb397cd4
should obviously fix both problems.

Thanks,

Oleg.

