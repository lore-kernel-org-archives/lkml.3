Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933803Ab3CTQw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:52:28 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55915 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab3CTQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:52:15 -0400
Date: Wed, 20 Mar 2013 09:53:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_mmap and
 ashmem_read
Message-ID: <20130320165339.GA28307@kroah.com>
References: <CAJsYZ5ksvPCR2O39=sj9zeptfppP1w6FM08rw8Aw+L+2dEPCnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJsYZ5ksvPCR2O39=sj9zeptfppP1w6FM08rw8Aw+L+2dEPCnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 09:08:03PM +0530, Shankar Brahadeeswaran wrote:
> Hi Greg, Dan,
> 
> Few days back I posted a patch to fix a dead lock issue in the ashmem
> driver that got merged in staging-next branch
> https://lkml.org/lkml/2013/2/20/429
> 
> I'm seeing that there exists another path in the ashmem driver that
> could lead to the similar issue. But this time I'm unable to think of
> a way to fix the problem.

Why not copy the android developers who wrote this code on this thread?

greg k-h
