Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaFMSzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:55:21 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:54677 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbaFMSzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:55:15 -0400
Date: Fri, 13 Jun 2014 13:55:12 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] percpu: reorganize include/linux/percpu-defs.h
In-Reply-To: <20140613182538.GB3723@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1406131354210.24349@gentwo.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org> <1402590209-31610-6-git-send-email-tj@kernel.org> <alpine.DEB.2.10.1406131215330.1717@gentwo.org> <20140613182538.GB3723@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Tejun Heo wrote:

> On Fri, Jun 13, 2014 at 12:16:27PM -0500, Christoph Lameter wrote:
> > On Thu, 12 Jun 2014, Tejun Heo wrote:
> >
> > > +#define __raw_get_cpu_var(var)	(*raw_cpu_ptr(&(var)))
> > > +#define __get_cpu_var(var)	(*this_cpu_ptr(&(var)))
> >
> > At the conclusion of the current &get_cpu_var patchset these two
> > definitions are scheduled to be removed.
>
> Yeah, dropping that part isn't difficult.  Where's the &get_cpu_var
> patchset now?  Is it gonna make it into v3.16-rc1?

Pieces are flowing in for that through various trees. I can post the
remaining patches once v3.16 is out.


