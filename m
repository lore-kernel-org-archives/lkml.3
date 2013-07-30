Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3G3V2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:28:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3G3V2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:28:21 -0400
Date: Tue, 30 Jul 2013 14:28:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-Id: <20130730142820.313f1af6827276df31913106@linux-foundation.org>
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 12:50:26 -0500 Dave Kleikamp <dave.kleikamp@oracle.com> wrote:

> This patch series adds a kernel interface to fs/aio.c so that kernel code can
> issue concurrent asynchronous IO to file systems.  It adds an aio command and
> file system methods which specify io memory with pages instead of userspace
> addresses.
> 
> This series was written to reduce the current overhead loop imposes by
> performing synchronus buffered file system IO from a kernel thread.  These
> patches turn loop into a light weight layer that translates bios into iocbs.

Do you have any performance numbers?

Does anyone care much about loop performance?  What's the value here?
