Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaHUNNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:13:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaHUNNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:13:01 -0400
Date: Thu, 21 Aug 2014 06:12:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
Message-ID: <20140821131257.GA4264@infradead.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
 <CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
 <87vbpm4f4y.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vbpm4f4y.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 09:53:49PM -0700, Eric W. Biederman wrote:
> Richard Weinberger <richard.weinberger@gmail.com> writes:
> 
> > On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> > This commit breaks libvirt-lxc.
> > libvirt does in lxcContainerMountBasicFS():
> 
> The bugs fixed are security issues, so if we have to break a small
> number of userspace applications we will.  Anything that we can
> reasonably do to avoid regressions will be done.

Can you explain the security issues in detail?  Breaking common
userspace like libvirt-lxc with just a little bit of handwaiving is
entirely unacceptable.

