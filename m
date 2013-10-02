Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3JBLea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:34:30 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38843 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3JBLe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:34:28 -0400
MIME-Version: 1.0
In-Reply-To: <20131002111958.GC10099@krava.brq.redhat.com>
References: <CALkWK0k5sQ9WCGevFQ3D18=Fs3ziS8imVVvasE0QR9e0r91cYA@mail.gmail.com>
 <20131002111958.GC10099@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Wed, 2 Oct 2013 17:03:48 +0530
Message-ID: <CALkWK0mCbnBZXJNFyX3odoGb1pvGs7ox1mOiFacqX98ewBOGKw@mail.gmail.com>
Subject: Re: [BUG] perf timechart segfault
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Jiri Olsa wrote:
> what perf version are you running?

I'm running off the one in torvalds/linux.git.

$ perf --version
perf version 3.12.rc3.g34b22d5

The log of builtin-timechart.c shows that it was last touched by you
three months ago: 5936678 (perf timechart: Remove event types
framework only user, 2013-07-11). Are there some patches awaiting
merge that I'm missing?
