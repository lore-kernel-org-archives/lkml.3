Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaBLA1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 19:27:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaBLA1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 19:27:48 -0500
Date: Tue, 11 Feb 2014 16:27:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [process_vm_access] BUG: unable to handle kernel paging request
 at fffffff27b92dd20
Message-Id: <20140211162745.c4fdb96ec58fa9581e6c2841@linux-foundation.org>
In-Reply-To: <20140210112231.GA11951@localhost>
References: <20140210112231.GA11951@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 19:22:31 +0800 Fengguang Wu <fengguang.wu@intel.com> wrote:

> We noticed the below oops since commit 68a25f08c9bec07ad95e55a01b127168e43aed84
> ("process_vm_access: take get_user_pages/put_pages one level up")
> while running ltp tests inside kvm.

I can't find this patch anywhere.  Where did it come from?
