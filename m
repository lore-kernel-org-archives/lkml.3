Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaGHUYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:24:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaGHUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:24:10 -0400
Date: Tue, 8 Jul 2014 13:24:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] checkpatch: Add ability to insert and delete lines
 to patch/file
Message-Id: <20140708132409.625c8c90c49b9db9efe6eb8d@linux-foundation.org>
In-Reply-To: <678bea67f00c0b59cb17d0e9ee722e0ab0616b43.1404840958.git.joe@perches.com>
References: <cover.1404840958.git.joe@perches.com>
	<678bea67f00c0b59cb17d0e9ee722e0ab0616b43.1404840958.git.joe@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Jul 2014 10:53:36 -0700 Joe Perches <joe@perches.com> wrote:

> This can be valuable to insert or delete blank lines as well
> as fix misplaced brace or else uses.

hm, do we really want to go down this path?  It's a very long one and
it leads to /usr/bin/indent?

