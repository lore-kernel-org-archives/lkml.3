Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935957AbaH0Va6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:30:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0Va4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:30:56 -0400
Date: Wed, 27 Aug 2014 14:30:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        willy@linux.intel.com
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
Message-Id: <20140827143055.5210c5fb9696e460b456eb26@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.11.1408271616070.17080@gentwo.org>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
	<20140827130613.c8f6790093d279a447196f17@linux-foundation.org>
	<alpine.DEB.2.11.1408271616070.17080@gentwo.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014 16:22:20 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:

> > Some explanation of why one would use ext4 instead of, say,
> > suitably-modified ramfs/tmpfs/rd/etc?
> 
> The NVDIMM contents survive reboot and therefore ramfs and friends wont
> work with it.

See "suitably modified".  Presumably this type of memory would need to
come from a particular page allocator zone.  ramfs would be unweildy
due to its use to dentry/inode caches, but rd/etc should be feasible.

I dunno, I'm not proposing implementations - I'm asking obvious
questions.  Stuff which should have been addressed in the changelogs
before one even starts to read the code...

