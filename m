Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab3FFRzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3FFRzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:55:37 -0400
Date: Thu, 6 Jun 2013 13:55:29 -0400
From: Kyle McMartin <kyle@redhat.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, rob@landley.net,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Kbuild: pass headers to headers_install.sh on stdin
Message-ID: <20130606175529.GT14762@redacted.bos.redhat.com>
References: <20130606170557.GQ14762@redacted.bos.redhat.com>
 <51B0C9E5.7030105@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0C9E5.7030105@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 07:41:57PM +0200, Michal Marek wrote:
> Dne 6.6.2013 19:05, Kyle McMartin napsal(a):
> > While using make V=1 to test some things, I noticed on our builders that
> > headers_install was failing because the argument list to /bin/sh was too
> > long. Working around it is slightly kludgy...
> 
> This is already fixed with
> 
> 
> commit c0ff68f1611d6855a06d672989ad5cfea160a4eb
> Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date:   Mon Apr 29 14:15:51 2013 +0200
> 
>     kbuild: fix make headers_install when path is too long
> 
> 
> in linux-next.
> 

OK, I guess.

--Kyle
