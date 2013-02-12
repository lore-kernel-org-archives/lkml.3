Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3BLWHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:07:44 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:62042 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3BLWHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:07:43 -0500
MIME-Version: 1.0
In-Reply-To: <1360685171-3792-2-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
	<1360685171-3792-2-git-send-email-pbonzini@redhat.com>
Date: Tue, 12 Feb 2013 17:07:41 -0500
Message-ID: <CAECXXi48FL94m=hUZYRWgS=5Z3R1J5oZsOjX65X6utfZdBafnA@mail.gmail.com>
Subject: Re: [PATCH 1/3] nbd: support FLUSH requests
From: Paul Clements <paul.clements@us.sios.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alex Bligh <alex@alex.org.uk>,
        nbd-general@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:06 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> From: Alex Bligh <alex@alex.org.uk>
>
> The NBD device does not support writeback caching, thus it is not safe
> against power losses unless the client opens the target with O_DSYNC or
> O_SYNC.
>
> Add support for a new flag that the server can pass.  If the flag is
> enabled, we translate REQ_FLUSH requests into the NBD_CMD_FLUSH
> command.
>
> Cc: <nbd-general@lists.sf.net>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Alex Bligh <alex@alex.org.uk>

Looks good.

Acked-by: Paul.Clements@steeleye.com
