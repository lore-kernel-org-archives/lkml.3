Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab3IEXOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 19:14:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab3IEXOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 19:14:33 -0400
Message-ID: <1378422869.3246.282.camel@ul30vt.home>
Subject: Re: linux-next: back merge of Linus' tree into the vfio tree
From: Alex Williamson <alex.williamson@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Sep 2013 17:14:29 -0600
In-Reply-To: <20130906090826.947212e7d5383837bff881f5@canb.auug.org.au>
References: <20130906090826.947212e7d5383837bff881f5@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-06 at 09:08 +1000, Stephen Rothwell wrote:
> Hi Alex,
> 
> I noticed that you have back merged Linus' tree into yours.  Linus
> usually takes a dim view of that - especially when there is no
> explanation in the merge commit message.  i.e. you shouldn't to that
> unless you really need to - and then you should explain why you did it.

Hmm, I was hoping that wouldn't be a problem, especially with no
conflicts in the merge.  I did it because the first commit after the
merge in my next tree depends on PCI changes that have already been
merged by Linus.  Re-basing is an even bigger sin and I felt it better
to do a merge than ask for two pulls or add an unbuild-able commit to my
next tree.  How do you suggest that I resolve this?  Thanks,

Alex



