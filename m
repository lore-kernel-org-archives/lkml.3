Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaILVzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:55:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaILVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:54:58 -0400
Date: Fri, 12 Sep 2014 14:54:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH 1/2] fs: proc: use __seq_open_private()
Message-Id: <20140912145456.863d25e38db6fa5dea60845d@linux-foundation.org>
In-Reply-To: <1410530978-29627-2-git-send-email-rob.jones@codethink.co.uk>
References: <1410530978-29627-1-git-send-email-rob.jones@codethink.co.uk>
	<1410530978-29627-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 15:09:37 +0100 Rob Jones <rob.jones@codethink.co.uk> wrote:

> Reduce boilerplate code by using __seq_open_private() instead of seq_open().

http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
already did this.
