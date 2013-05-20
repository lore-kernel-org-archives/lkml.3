Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3ETXja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:39:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282Ab3ETXj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:39:29 -0400
Date: Mon, 20 May 2013 16:39:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-Id: <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org>
In-Reply-To: <1367270313-18871-3-git-send-email-phdm@macqel.be>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be>
	<1367270313-18871-3-git-send-email-phdm@macqel.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013 23:18:30 +0200 Philippe De Muyter <phdm@macqel.be> wrote:

> adding partitions/aix.h and partitions/aix.c
> 
> Partitions (called Logical Volumes in AIX) can be non-contiguous or
> even split on more than one disk.  Altough we detect such partitions,
> we cannot describe them to the Linux partitions layer, so we simply
> discard them and issue a diagnose message.

This description is rather hard to follow.

It appears that the new code permits Linux to access some types of AIX
partitions, but not other types, correct?  If so, can we please provide
a more explicit description of which typesw are and are not supported?


