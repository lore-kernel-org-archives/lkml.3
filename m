Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaCUUjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:39:06 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42614 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaCUUjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:39:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140319102711.84f68cdb4a7b7acfd945fe74@canb.auug.org.au>
References: <20140318124107.GA24890@osiris>
	<CA+8MBbKaaYXNV_XZNRp=wn-+3Mqd4+JVoXn_d+eo=PQR17i1SQ@mail.gmail.com>
	<20140318161050.ab184d30edf4b2446a2060de@linux-foundation.org>
	<20140319102711.84f68cdb4a7b7acfd945fe74@canb.auug.org.au>
Date: Fri, 21 Mar 2014 13:39:02 -0700
Message-ID: <CA+8MBbL849jdqGsFuS1Wu296m3=MDGAz9gef9A102pbfm5OLtw@mail.gmail.com>
Subject: Re: [BUG -next] "mm: per-thread vma caching fix 5" breaks s390
From: Tony Luck <tony.luck@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Sasha Levin <sasha.levin@oracle.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem is no longer present in next-20140321.

-Tony
