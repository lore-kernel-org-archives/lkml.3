Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaDQUh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:37:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDQUhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:37:47 -0400
Date: Thu, 17 Apr 2014 13:37:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: xypron.glpk@gmx.de
Cc: eparis@redhat.com, jack@suse.cz, mtk.manpages@gmail.com,
        tvrtko.ursulin@onelan.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Avoid having to provide a fake/invalid fd and path
Message-Id: <20140417133746.080346a8b40708a621997af2@linux-foundation.org>
In-Reply-To: <1395847805-6714-1-git-send-email-xypron.glpk@gmx.de>
References: <1395847805-6714-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2014 16:30:05 +0100 xypron.glpk@gmx.de wrote:

> From: Heinrich Schuchardt <xypron.glpk@gmx.de>
> 
> https://lkml.org/lkml/2011/1/12/112
> holds a patch by Tvrtko Ursulin
> 
>   Avoid having to provide a fake/invalid fd and path when flushing marks
> 
>   Currently for a group to flush marks it has set it needs to
>   provide a fake or invalid (but resolvable) file descriptor
>   and path when calling fanotify_mark. This patch pulls the
>   flush handling a bit up so file descriptor and path are
>   completely ignored when flushing.

The fanotify_mark() manpage should be updated to mention this.  Is that
a thing you can take care of? 
