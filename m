Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509Ab3DPWHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425Ab3DPWHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:07:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHGf_=r+qoL8_J+z8Y1uPt_NK1Ef4cLuapAvVd-7qF8+_oSjJw@mail.gmail.com>
References: <CAHGf_=r+qoL8_J+z8Y1uPt_NK1Ef4cLuapAvVd-7qF8+_oSjJw@mail.gmail.com> <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182601.27773.46395.stgit@warthog.procyon.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mips@linux-mips.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        x86@kernel.org, sparclinux@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 03/28] proc: Split kcore bits from linux/procfs.h into linux/kcore.h [RFC]
Date: Tue, 16 Apr 2013 23:07:37 +0100
Message-ID: <30949.1366150057@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> I have no seen any issue in this change. but why? Is there any
> motivation rather than cleanup?

Stopping stuff mucking about with the internals of procfs incorrectly
(sometimes because the internals of procfs have changed, but the drivers
haven't).

David
