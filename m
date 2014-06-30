Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaF3XTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 19:19:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaF3XTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 19:19:46 -0400
Date: Mon, 30 Jun 2014 16:19:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs.h: Remove unnecessary extern prototypes
Message-Id: <20140630161944.bd57016cba11f47185dbe6c5@linux-foundation.org>
In-Reply-To: <c81908e88f71ca2c21a8e3eaf3e5f72bd8d6c322.1403999769.git.joe@perches.com>
References: <cover.1403999769.git.joe@perches.com>
	<c81908e88f71ca2c21a8e3eaf3e5f72bd8d6c322.1403999769.git.joe@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 17:20:13 -0700 Joe Perches <joe@perches.com> wrote:

> This file has a mixture of prototypes with and without extern.
> Remove the extern uses.

urgh, it's been two days and this already throws a huge reject.  I fix
that and the other two patches throw great piles of rejects as well.

Dunno.  Maybe `diff -u1' will make it feasible.
