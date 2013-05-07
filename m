Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab3EGVYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:24:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119Ab3EGVYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:24:48 -0400
Date: Tue, 7 May 2013 14:24:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/11] mm: fixup changers of per cpu pageset's ->high
 and ->batch
Message-Id: <20130507142446.52214bb184bed45635febeb3@linux-foundation.org>
In-Reply-To: <5181AB06.5080805@linux.vnet.ibm.com>
References: <1365618219-17154-1-git-send-email-cody@linux.vnet.ibm.com>
	<20130410142354.6044338fd68ff2ad165b1bc8@linux-foundation.org>
	<5165D8DE.5090801@linux.vnet.ibm.com>
	<5181AB06.5080805@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 May 2013 16:53:42 -0700 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> >> There hasn't been a ton of review activity for this patchset :(
> >>
> >> I'm inclined to duck it until after 3.9.  Do the patches fix any
> >> noticeably bad userspace behavior?
> >
> > No, all the bugs are theoretical. Waiting should be fine.
> >
> 
> Andrew, do you want me to resend this patch set in the hope of obtaining 
> more review?

Yes please.  Resending is basically always the thing to do - if the
patches aren't resent, nobody has anything to look at or think about.

> If so, when?

After -rc1?
