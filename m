Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3IYUD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:03:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3IYUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:03:54 -0400
Date: Wed, 25 Sep 2013 13:03:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@ZenIV.linux.org.uk>, Andy Whitcroft <apw@shadowen.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-Id: <20130925130352.0e89fd9439eff93c69cdcc32@linux-foundation.org>
In-Reply-To: <52433F89.5050104@ahsoftware.de>
References: <1380047934.3575.100.camel@joe-AO722>
	<20130925152432.GY13318@ZenIV.linux.org.uk>
	<1380123344.17366.5.camel@joe-AO722>
	<20130925161949.GZ13318@ZenIV.linux.org.uk>
	<1380136920.17366.15.camel@joe-AO722>
	<20130925193035.GA11905@thunk.org>
	<1380138515.17366.22.camel@joe-AO722>
	<52433F89.5050104@ahsoftware.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 21:54:49 +0200 Alexander Holler <holler@ahsoftware.de> wrote:

> Am 25.09.2013 21:48, schrieb Joe Perches:
> 
> > As I've said multiple times, checkpatch is a stupid
> > little tool that can be ignored by anyone with
> > different tastes.
> 
> Just that this isn't true for ordinary innocent people posting patches.

Nobody uses --strict.  Discussion is silly.
