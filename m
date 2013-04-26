Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3DZSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:25:29 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53526 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3DZSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:25:28 -0400
Date: Fri, 26 Apr 2013 11:25:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: shea@shealevy.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.8.9
Message-ID: <20130426182524.GA7166@kroah.com>
References: <20130426042722.GA24693@kroah.com>
 <0d001ac0b7c1a1bc02f47a4ee08c64df@shealevy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d001ac0b7c1a1bc02f47a4ee08c64df@shealevy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 02:02:31PM -0400, shea@shealevy.com wrote:
> Hi Greg,
> 
> I think 37ed4a3 requires 935d8aa from upstream, otherwise there's a
> compile error when user namespaces are enabled:
> 
> linux-3.8.9/kernel/user_namespace.c: In function 'map_write':
> linux-3.8.9/kernel/user_namespace.c:582:2: error: implicit
> declaration of function 'file_ns_capable'
> [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Ugh, you are right, I missed that.  I'll go do a 3.8.10 release now with
that fix in it, thanks for pointing it out.

greg k-h
