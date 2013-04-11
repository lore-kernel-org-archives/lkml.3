Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462Ab3DKOLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:11:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3DKOLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:11:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/26] Eliminate create_proc_read_entry() [RFC]
Date: Thu, 11 Apr 2013 16:11:05 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111611.05520.arnd@arndb.de>
X-Provags-ID: V02:K0:1L78XCwctXrXRYFHKCcW4J+YP/hQfxgjQEZgeGjF8g1
 yzj7PMdWsl9dbx8tvb8ohrb3W2r9jZtYPi3JI5ZaQC/bQkfKPQ
 2I7fzfrUAzl2s979aE9OymK0RLrezt412nBDE5lCc27x4vOp83
 UTpUUKwCDkVp9NN6KzX5wD9uVXAF8ZbEu6ziQ+5pHspAZjx2LH
 ndMuLNoTy1S+W6mCG1elDO/SjtvTWmY17EW69jOGjlmtqmzB2r
 jb652ZpX42DPG6cEh4LIm+sR3g03XWXnKdoq8nLxH3jlux1oE2
 16CbiUX0N/+7idvK48lUahaeg208j7VPQi1mcPDWK4iowuqtI4
 Vi+4VkS0um/S8v6hBIZA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, David Howells wrote:
> 
> Here is a series of patches to eliminate create_proc_read_entry(), replacing it
> with proc_create() and proc_create_data() and the use of seq_file facilities.
> These patches can be seen here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=vfs-experimental

Nice series. I did something  similar about two years ago but never got
around to actually send them. If you like you can take a look at

   git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git procfs

for my patches and see if how I did them for comparison. They are based on linux-3.1 though.

	Arnd
