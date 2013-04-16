Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459Ab3DPVhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:37:38 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:32866 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344Ab3DPVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:37:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130416182601.27773.46395.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182601.27773.46395.stgit@warthog.procyon.org.uk>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 16 Apr 2013 14:37:14 -0700
Message-ID: <CAHGf_=r+qoL8_J+z8Y1uPt_NK1Ef4cLuapAvVd-7qF8+_oSjJw@mail.gmail.com>
Subject: Re: [PATCH 03/28] proc: Split kcore bits from linux/procfs.h into
 linux/kcore.h [RFC]
To: David Howells <dhowells@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, x86@kernel.org,
        sparclinux@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:26 AM, David Howells <dhowells@redhat.com> wrote:
> Split kcore bits from linux/procfs.h into linux/kcore.h.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-mips@linux-mips.org
> cc: sparclinux@vger.kernel.org
> cc: x86@kernel.org
> cc: linux-mm@kvack.org

I have no seen any issue in this change. but why? Is there any
motivation rather than cleanup?
