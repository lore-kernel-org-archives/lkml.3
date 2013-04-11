Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936394Ab3DKVTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:19:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935467Ab3DKVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:19:46 -0400
Date: Thu, 11 Apr 2013 14:19:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] pagemap: Introduce the /proc/PID/pagemap2 file
Message-Id: <20130411141944.dc17b3b1c78132eedec06aa6@linux-foundation.org>
In-Reply-To: <51669EA5.20209@parallels.com>
References: <51669E5F.4000801@parallels.com>
	<51669EA5.20209@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013 15:29:41 +0400 Pavel Emelyanov <xemul@parallels.com> wrote:

> This file is the same as the pagemap one, but shows entries with bits
> 55-60 being zero (reserved for future use). Next patch will occupy one
> of them.

I'm not understanding the motivation for this.  What does the current
/proc/pid/pagemap have in those bit positions?

