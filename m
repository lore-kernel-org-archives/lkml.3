Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaJ1Bc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:32:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42932 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJ1BcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:32:24 -0400
Date: Mon, 27 Oct 2014 18:32:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Steve Capper <steve.capper@linaro.org>,
        Andrea Arcangeli <aarcange@redhat.com>, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V3 1/2] mm: Update generic gup implementation to handle
 hugepage directory
Message-Id: <20141027183241.a5339085.akpm@linux-foundation.org>
In-Reply-To: <1414459229.31711.0.camel@concordia>
References: <1414233860-7683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20141027160612.b7fd0b1cc9d82faeaa674940@linux-foundation.org>
	<1414459229.31711.0.camel@concordia>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 12:20:29 +1100 Michael Ellerman <mpe@ellerman.id.au> wrote:

> On Mon, 2014-10-27 at 16:06 -0700, Andrew Morton wrote:
> > On Sat, 25 Oct 2014 16:14:19 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > Update generic gup implementation with powerpc specific details.
> > > On powerpc at pmd level we can have hugepte, normal pmd pointer
> > > or a pointer to the hugepage directory.
> > 
> > I grabbed these.  It would be better if they were merged into the powerpc
> > tree where they'll get more testing than in linux-next alone.
>  
> Fine by me. Can I get an ack from you and/or someone else on CC?
> 

Only arm and arm64 use this code.  Steve, could you please look it over
and check that arm is still happy?
