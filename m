Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3DQA6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:58:06 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34910 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3DQA6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:58:04 -0400
Date: Tue, 16 Apr 2013 17:57:53 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Jri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 09/28] proc: Move some bits from linux/proc_fs.h to
 linux/{of.h, signal.h, tty.h} [RFC]
Message-ID: <20130417005753.GB11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182626.27773.48524.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182626.27773.48524.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:26:26PM +0100, David Howells wrote:
> Move some bits from linux/proc_fs.h to linux/of.h, signal.h and tty.h.
> 
> Also move proc_tty_init() and proc_device_tree_init() to fs/proc/internal.h as
> they're internal to procfs.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: devicetree-discuss@lists.ozlabs.org
> cc: linux-arch@vger.kernel.org
> cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> cc: Jri Slaby <jslaby@suse.cz>
> ---

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
