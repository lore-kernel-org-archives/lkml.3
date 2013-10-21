Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab3JUHdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 03:33:04 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:56527 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab3JUHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 03:33:03 -0400
MIME-Version: 1.0
In-Reply-To: <20131018150903.22f75457@gandalf.local.home>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
	<CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
	<20131002185723.GA32614@redhat.com>
	<1380745082.12351.6.camel@pippen.local.home>
	<20131002223437.GA15728@redhat.com>
	<CAAeHK+wTs3THbh+EVoTm0wqQH8cg2VbT8aKYBX67A385+ohq0w@mail.gmail.com>
	<20131009222323.04fd1a0d@gandalf.local.home>
	<CAAeHK+zdgEFHkOYgqs2FT0a3KBumQ3NUjftoNzzVic+tjf29RQ@mail.gmail.com>
	<20131018150903.22f75457@gandalf.local.home>
Date: Mon, 21 Oct 2013 11:33:01 +0400
Message-ID: <CAAeHK+x_eWn7xoTAgXGzrKg++a8MctNw-s2=T4Gba_zOO-UoDA@mail.gmail.com>
Subject: Re: Potential out-of-bounds in ftrace_regex_release
From: Andrey Konovalov <andreyknvl@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        mingo@redhat.com, Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 11:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Can I assume that this is fixed? I'll put it in for 3.12 and mark  it
> for stable too.

I think yes. OK.
