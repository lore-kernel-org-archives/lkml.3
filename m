Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaE2Wmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:42:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaE2Wmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:42:51 -0400
Date: Thu, 29 May 2014 15:42:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Dave Jones <davej@redhat.com>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH] fs: ocfs2: move_extents.c: Fix to remove null pointer
 checks that could never happen
Message-Id: <20140529154250.4be24a07ec68eb2eef41e8e2@linux-foundation.org>
In-Reply-To: <CAFo99gZm0b8QodT56r+wegY7LM=oWFqLmpE5cnN_MaiBrx1Fqg@mail.gmail.com>
References: <1401222231-21656-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140529140337.f999bfaaf9ffabce071962ea@linux-foundation.org>
	<20140529212308.GA16353@redhat.com>
	<20140529143840.d6fd12bc4e3cfc8d24730b6d@linux-foundation.org>
	<CAFo99gZm0b8QodT56r+wegY7LM=oWFqLmpE5cnN_MaiBrx1Fqg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 00:39:24 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> Hi all!
> 
> First, I'm no expert on this code, but after a patch which I thought
> was most accurate for the current code was written before, which was
> rather something like the code below.
> Then Jeff Liu that this was not something that could happen. So I send
> a patch where the check was removed instead.
> And that's where we are now. :-)
> 

Well if Jeff says that inode==NULL cannot happen then that is the info
I was after, and the original patch is OK.  Please resend, with that
important info in the changelog ;)

