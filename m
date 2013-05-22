Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3EVHPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:15:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3EVHPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:15:18 -0400
Date: Wed, 22 May 2013 00:14:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dborkman@redhat.com,
        netdev@vger.kernel.org, nschichan@freebox.fr
Subject: Re: linux-next: manual merge of the akpm tree with the net-next
 tree
Message-Id: <20130522001458.af0f4ab5.akpm@linux-foundation.org>
In-Reply-To: <20130522.000748.454683591881350280.davem@davemloft.net>
References: <20130521142948.444f09820c5406f9adc4b7f1@canb.auug.org.au>
	<20130521130438.1ecdf535ab2461888abbe0c3@linux-foundation.org>
	<20130522.000748.454683591881350280.davem@davemloft.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 00:07:48 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 21 May 2013 13:04:38 -0700
> 
> > Nicolas, I think the patches need a re-check so I'll drop the versions
> > which I presently have.  Please refresh, retest and resend when
> > convenient?  It'll need to be against linux-next, which is where the
> > conflicting (vfree/module_free) changes have occurred.
> 
> How about working against net-next and submitting your patches to netdev
> just like the rest of the world?
> 

Well that's probably practical.  But the patchset is a seccomp
enhancement for (at present) ARM.  Not exactly net stuff, or anything
which netdev readers are likely to spend a lot of time testing and
reviewing.


