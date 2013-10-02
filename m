Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab3JBUTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:19:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:63976 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754199Ab3JBUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:19:19 -0400
Message-ID: <1380745082.12351.6.camel@pippen.local.home>
Subject: Re: Fwd: Potential out-of-bounds in ftrace_regex_release
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com,
        Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>
Date: Wed, 02 Oct 2013 16:18:02 -0400
In-Reply-To: <20131002185723.GA32614@redhat.com>
References: <CAAeHK+w+8=DGvFeuMAwS50RRvAGw1KkWHcivja5q-wmX8GtH2w@mail.gmail.com>
	 <CAAeHK+wy+vs2PniKh8DbWzZoS99g1eZ-U3mv+6SzoznC8WHW6A@mail.gmail.com>
	 <20131002185723.GA32614@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 14:57 -0400, Dave Jones wrote:

> And that's the cause. I wonder what was being opened.
> Do you happen to have a trinity-child log for that thread ?

Thanks for the update. This definitely looks like the bug, and explains
a lot. I'll look into this, as I'm currently at a conference, it may be
sporadic.

-- Steve


