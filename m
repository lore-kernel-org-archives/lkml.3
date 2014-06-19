Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339AbaFSVFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:05:32 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:48906 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965269AbaFSVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:05:31 -0400
Date: Thu, 19 Jun 2014 16:05:29 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET percpu/for-3.17] percpu: clean up percpu accessor and
 operation definitions
In-Reply-To: <20140617232202.GD8838@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406191603570.5484@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <20140617232202.GD8838@mtj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Tejun Heo wrote:

> >   linus master c31c24b8251f ("Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux")
> > + [1] [PATCH RFC] percpu: add data dependency barrier in percpu accessors and operations
>
> Omitted the data dependency barrier and applied the series to
> percpu/for-3.17.

Ok I hope all of that dependency material is removed from the tree?

