Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3JBTHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:07:00 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36031 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3JBTG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <20131002185723.GA32614@redhat.com>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
	<CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
	<20131002185723.GA32614@redhat.com>
Date: Wed, 2 Oct 2013 23:06:58 +0400
Message-ID: <CAAeHK+xOU-7bCU--fOw2_ebAd6hNnMKHjnp0_c-H1rZ+YCBBwg@mail.gmail.com>
Subject: Re: Fwd: Potential out-of-bounds in ftrace_regex_release
From: Andrey Konovalov <andreyknvl@google.com>
To: Dave Jones <davej@redhat.com>, Andrey Konovalov <andreyknvl@google.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 10:57 PM, Dave Jones <davej@redhat.com> wrote:
> And that's the cause. I wonder what was being opened.
> Do you happen to have a trinity-child log for that thread ?

Unfortunately not.
