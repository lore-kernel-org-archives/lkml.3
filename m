Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311Ab3AQIHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:07:44 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32813 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229Ab3AQIHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:07:42 -0500
Date: Thu, 17 Jan 2013 00:07:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 85/86] mm: remove depends on CONFIG_EXPERIMENTAL
In-Reply-To: <1358391258-1771-86-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.00.1301170007150.27318@chino.kir.corp.google.com>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org> <1358391258-1771-86-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013, Kees Cook wrote:

> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Jan Beulich <JBeulich@novell.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
> CC: David Rientjes <rientjes@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for keeping ARCH_SELECT_MEMORY_MODEL around.
