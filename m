Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937535Ab3DJW5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:57:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937174Ab3DJW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:57:52 -0400
Date: Wed, 10 Apr 2013 15:57:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH] checkpatch: Warn on comparisons to true and false
Message-Id: <20130410155751.7ecc6738d616fb8771991ce1@linux-foundation.org>
In-Reply-To: <1365563834.27174.12.camel@joe-AO722>
References: <1365563834.27174.12.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Apr 2013 20:17:14 -0700 Joe Perches <joe@perches.com> wrote:

> Comparisons of A to true and false are better written
> as A and !A.
> 
> Bleat a message on use.

hm.  I'm counting around 1,100 instances of "== true" and "== false".

That's a lot of people to shout at.  Is it really worthwhile? 
"foo==true" is a bit of a waste of space but I can't say that I find it
terribly offensive.

