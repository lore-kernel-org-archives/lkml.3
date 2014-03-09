Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaCIHGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:06:50 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:55046 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaCIHGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:06:49 -0400
Date: Sun, 9 Mar 2014 09:06:42 +0200
From: Muli Ben-Yehuda <muli@cs.technion.ac.il>
To: Jon Mason <jdmason@kudzu.us>
Cc: "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vivek Goyal <vgoyal@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>,
        kexec@lists.infradead.org, discuss@x86-64.org, x86@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How could we get rid of saved_max_pfn for calgary iommu?
Message-ID: <20140309070642.GA2525@needle>
References: <20140219061824.GA29703@dhcp-17-89.nay.redhat.com>
 <20140305053617.GE26240@dhcp-17-89.nay.redhat.com>
 <20140306064756.GB16859@needle.mulix.org>
 <53181AC1.2020807@zytor.com>
 <20140306070047.GF16859@needle.mulix.org>
 <CAPoiz9yhAeoWDANus6=O_5AomKFEAzzR1pR4F0rN2HnDWwYAMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoiz9yhAeoWDANus6=O_5AomKFEAzzR1pR4F0rN2HnDWwYAMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 07:46:44AM -0700, Jon Mason wrote:

> > I don't know of anyone still using it, but it's not
> > impossible. Calgary and CalIOC2 machines would now be ~5-8 years
> > old.
> 
> It is getting a bit crufty in arch/x86.  Would it be better to move
> it to drivers/iommu?

Not sure I see the potential benefit... I think for Calgary it's
either leave it in arch/x86 or rip it out.

Cheers,
Muli
