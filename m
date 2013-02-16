Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3BPIOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:14:30 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58676 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPIO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:14:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130216074348.GC4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk> <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
 <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
 <20130216015024.GA4503@ZenIV.linux.org.uk> <20130216022006.GB4503@ZenIV.linux.org.uk>
 <CAGDaZ_oSzQOLsoeWQFNQ8R5-NBKPAUygvjvzvef9q40WBu1sWw@mail.gmail.com> <20130216074348.GC4503@ZenIV.linux.org.uk>
From: Raymond Jennings <shentino@gmail.com>
Date: Sat, 16 Feb 2013 00:13:47 -0800
Message-ID: <CAGDaZ_qKJvje6iAxf_N4X+NvcNgrrn+4HYEEzWoBGcxLH_i-tg@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mistake then.

I figured there was always a way to back out of something like this.

Carry on.
