Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaCMCtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:49:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaCMCtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:49:08 -0400
Date: Wed, 12 Mar 2014 19:53:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] generic early_ioremap support
Message-Id: <20140312195348.5eaccbef.akpm@linux-foundation.org>
In-Reply-To: <1394677788.5094.89.camel@deneb.redhat.com>
References: <1394677788.5094.89.camel@deneb.redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014 22:29:48 -0400 Mark Salter <msalter@redhat.com> wrote:

> Hi Andrew,
> 
> Could you add this series into the -mm tree for v3.15?
> 
> The following changes since commit c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-03-04 08:44:32 -0800)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/mosalter/linux.git tags/for-v3.15
> 
> for you to fetch changes up to b27e0658d90c63dc2696eca44f7701a903cb13c5:
> 
>   doc/kernel-parameters.txt: add early_ioremap_debug (2014-03-09 12:53:50 -0400)
> 
> ----------------------------------------------------------------
> generic early_ioremap support

Spose so.  I was hoping the x86 and arm people might do it.  Has there
been sufficient feedback from those parties?

I don't actually do git pulls - I'll grab the patches off the mailing
list, if they're up to date?  (Sorry, it doesn't come up very often
so it isn't worth getting set up for).
