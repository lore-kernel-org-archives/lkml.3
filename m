Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaILVuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:50:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaILVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:50:21 -0400
Date: Fri, 12 Sep 2014 14:50:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH 0/2] fs: proc: use seq_open_private()
Message-Id: <20140912145019.9e1665011c2d2e9bcb55f0c1@linux-foundation.org>
In-Reply-To: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 15:09:36 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:

>   fs: proc: use __seq_open_private()
>   fs: proc: use __seq_open_private()

See the problem?  We have two different patches, both named the same.

I renamed them to

	fs/proc/task_nommu.c: use __seq_open_private()
	fs/proc/task_mmu.c: use __seq_open_private()

I really don't understand this practice of replacing "/" with ": " in
patch titles.  Why not just use the "/"?
