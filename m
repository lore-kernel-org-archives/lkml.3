Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaDUOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:25:27 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:36267 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaDUOZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:25:23 -0400
Message-ID: <53552A50.9040005@gmail.com>
Date: Mon, 21 Apr 2014 16:25:20 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
CC: mtk.manpages@gmail.com, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
In-Reply-To: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2014 03:45 PM, Jeff Layton wrote:

[...]

> - * These cmd values will set locks that conflict with normal POSIX locks, but
> - * are "owned" by the opened file, not the process. This means that they are
> - * inherited across fork() like BSD (flock) locks, and they are only released
> - * automatically when the last reference to the the open file against which
> - * they were acquired is put.
> + * These cmd values will set locks that conflict with process-associated
> + * record  locks, but are "owned" by the opened file description, not the
> + * process. This means that they are inherited across fork() like BSD (flock)
> + * locks, and they are only released automatically when the last reference to
> + * the the open file against which they were acquired is put.


(Pre-existing) typo: s/the the/the/



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
