Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab3LHUkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 15:40:15 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:56713 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3LHUkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 15:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <1386478624.4748.19.camel@marge.simpson.net>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	<1386478624.4748.19.camel@marge.simpson.net>
Date: Sun, 8 Dec 2013 15:40:08 -0500
X-Google-Sender-Auth: Cj4rIKHXBCWxim1r9a5M6L7RtSc
Message-ID: <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Len Brown <lenb@kernel.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, my little x3550 (E5620) box is spending ~99% of its time in C3 per
> powertop, deepest state it has.

Please run turbostat, which always describes what the hardware does.
Depending on the version of powertop and the hardware involved,
it may be describing that the OS requested -- which is not always the same.

The hardware reserves the right to demote any requested C-state to a
shallower one.  Also, it is the hardware decision whether to promote
core c-states requested by the OS into power saving package C-states.

cheers,
Len Brown, Intel Open Source Technology Center
