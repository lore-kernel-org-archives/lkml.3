Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3F0PjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:39:23 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:34704 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab3F0PjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:39:21 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAAq6er2nbOy6FEGxySSG7w_Dww50yTbwu5KH5E9PdbEedL6qbg@mail.gmail.com>
References: <1371903270-29584-1-git-send-email-apw@canonical.com>
	<CAAq6er2nbOy6FEGxySSG7w_Dww50yTbwu5KH5E9PdbEedL6qbg@mail.gmail.com>
Date: Thu, 27 Jun 2013 17:39:20 +0200
Message-ID: <CAJfpegvMjY5Zw-WZaWutv=JSr4RPY0Uj2=ytARtP1hW5ofQPFw@mail.gmail.com>
Subject: Re: [PATCH 1/1] UBUNTU: SAUCE: ubuntu: overlayfs -- ovl_path_open
 should not take path reference
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 2:18 PM, Andy Whitcroft <apw@canonical.com> wrote:
> Bah, forgot to strip the Ubuntu patch tracking prefixes from the patch.
> Obviously the subject should be:
>
>     overlayfs -- ovl_path_open should not take path reference

Thanks, fix pushed out to .v17 and .current (v.18) branches.

Miklos
