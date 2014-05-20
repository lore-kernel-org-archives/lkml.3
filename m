Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaETHpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:45:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaETHpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:45:42 -0400
Date: Tue, 20 May 2014 09:45:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 06/20] perf tools: Consolidate output field handling to
 hpp format routines
Message-ID: <20140520074516.GC1085@krava>
References: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
 <1400480762-22852-7-git-send-email-namhyung@kernel.org>
 <20140519131257.GC20810@krava.brq.redhat.com>
 <1400507671.1742.4.camel@leonhard>
 <CAM9d7cjocpy-rgKhOR=RHo0_oUC36UycEv5SmSP2t3Ty8Pozwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cjocpy-rgKhOR=RHo0_oUC36UycEv5SmSP2t3Ty8Pozwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 02:22:21AM +0000, Namhyung Kim wrote:
> Jiri,
> 
> I updated my -v6 branch to fix the breakage - move the hunk to 15/20.
> Do you want me to resend or would you review with this thread
> directly?  Either way would be find to me.

np, I can take it from branch

jirka
