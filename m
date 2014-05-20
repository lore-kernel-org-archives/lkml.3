Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaETMBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:01:23 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:45316 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaETMBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:01:22 -0400
Date: Tue, 20 May 2014 13:00:17 +0100
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist
 periods (v9)
Message-ID: <20140520120017.GC29706@sdfg.com.ar>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
 <20140519151120.GE24333@sdfg.com.ar>
 <CAM9d7cjVpFL0Vx48Pq6vR5OfnAvCAn7YkkJJS=bm6UqU=W5TOw@mail.gmail.com>
 <20140520030643.GB29706@sdfg.com.ar>
 <20140520073508.GA1085@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520073508.GA1085@krava>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 09:35:08AM +0200, Jiri Olsa wrote:
> On Tue, May 20, 2014 at 04:06:43AM +0100, Rodrigo Campos wrote:
> > On Tue, May 20, 2014 at 02:29:31AM +0000, Namhyung Kim wrote:
> > > Hi Rodrigo,
> > > 
> > > On Mon, May 19, 2014 at 3:11 PM, Rodrigo Campos <rodrigo@sdfg.com.ar> wrote:
> > > > Is there something I can help to have this merged ? As far as I tested, this
> > > > works fine here. Or is this ok, just waiting on the "perf report: Add -F option for
> > > > specifying output fields" patchset ?
> 
> I plan to do it today, can I use your Tested-by ?

Sure :-)




Thanks a lot,
Rodrigo
