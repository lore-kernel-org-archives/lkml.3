Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaFIDbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 23:31:10 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:37248 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaFIDbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 23:31:01 -0400
From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: Linux 3.15 .. and continuation of merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com>
References: <CA+55aFw3A=ycq4kRpsDDoV4+rzg0z2kwfE9C9Bg1nSwiYfUpLw@mail.gmail.com>
Date: Mon, 09 Jun 2014 12:30:34 +0900
Message-ID: <13591.1402284634@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds:
> So I ended up doing an rc8 because I was a bit worried about some
> last-minute dcache fixes, but it turns out that nobody seemed to even
> notice those. We did have other issues during the week, though, so it
	:::

I am afraid there is a problem in dcache. Please read
http://marc.info/?l=linux-fsdevel&m=140214911608925&w=2


For 3.16, please consider these patches.

- for vfs
  [PATCH v2] vfs: get_next_ino(), never inum=0
  http://marc.info/?l=linux-fsdevel&m=140128600801771&w=2

- for tmpfs
  [RFC PATCH v4 0/2] tmpfs: manage the inode-number by IDR (performance measure)
  http://marc.info/?l=linux-fsdevel&m=140197128021025&w=2
  [RFC PATCH v4 1/2] tmpfs: manage the inode-number by IDR, signed int inum
  http://marc.info/?l=linux-fsdevel&m=140197128321029&w=2
  [RFC PATCH v4 2/2] tmpfs: refine a file handle for NFS-exporting
  http://marc.info/?l=linux-fsdevel&m=140197128121026&w=2


J. R. Okajima
