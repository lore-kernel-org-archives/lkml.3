Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaG1PFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:05:53 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:59878 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752694AbaG1PFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:05:46 -0400
Date: Mon, 28 Jul 2014 10:05:43 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <CAJhHMCCXFEwZmUPsTo+nKuLj=n4m0fNB3Jt2NLWNnAcMH8r7Yw@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1407281005290.13286@gentwo.org>
References: <1405913633-4619-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407231752350.20654@gentwo.org> <CAJhHMCCXFEwZmUPsTo+nKuLj=n4m0fNB3Jt2NLWNnAcMH8r7Yw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Pranith Kumar wrote:

> > Well even any low late of remote writes still evicts the performance
> > sensitive  cacheline from the processor that needs it. Should it be asleep
> > and wake up then it will be missing the cacheline so the wakeup times are
> > prolonged.
> >
> >
>
> Yes, that can be the case. Should I add this para to the text?

Yes something to that effect.

