Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3HEJSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 05:18:10 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35152 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3HEJSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 05:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130805091221.GB26940@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
	<20130805081641.GA24808@gmail.com>
	<20130805082320.GA9562@infradead.org>
	<87fvuozerv.fsf@sejong.aot.lge.com>
	<20130805091221.GB26940@gmail.com>
Date: Mon, 5 Aug 2013 12:18:03 +0300
X-Google-Sender-Auth: 6J_HyLWz1TmKqbYbeTsNeAXDYbI
Message-ID: <CAOJsxLFfYPkw7jsfpvp49u9CYZivVGHNEg_2F8V3SiXx1gRzsw@mail.gmail.com>
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk executable
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:12 PM, Ingo Molnar <mingo@kernel.org> wrote:
> Assuming that in the normal case it can be made to work like a full build
> of perf today (i.e. without forcing LD_PRELOAD) then splitting the
> libraries away looks like a much better solution than splitting the
> binary.

Yup, if we can make it work, it's probably the best option. I'm not very
keen on splitting the binary but pulling all the GTK dependencies
like we do now is definitely a problem.

                        Pekka
