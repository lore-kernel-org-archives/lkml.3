Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3A2Khs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:37:48 -0500
Received: from ozlabs.org ([203.10.76.45]:57202 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab3A2Khq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:37:46 -0500
Message-ID: <1359455863.26096.2.camel@concordia>
Subject: Re: [PATCH v7 07/18] perf: add generic memory sampling interface
From: Michael Ellerman <michael@ellerman.id.au>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Maynard Johnson <mpjohn@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Date: Tue, 29 Jan 2013 21:37:43 +1100
In-Reply-To: <CABPqkBRpTPcJOohtujR6kk4tAHDFNCv24Ha6E0v1p5MRkPpy6A@mail.gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	 <1359040242-8269-8-git-send-email-eranian@google.com>
	 <20130125090158.GB31478@gmail.com>
	 <CABPqkBRpTPcJOohtujR6kk4tAHDFNCv24Ha6E0v1p5MRkPpy6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 16:30 +0100, Stephane Eranian wrote:
> On Fri, Jan 25, 2013 at 10:01 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Would be nice to get feedback from PowerPC folks to see how well
> > this matches their memory profiling hw capabilities?
> >
> I agree, I tried to remain as generic as possible here but I probably
> don't have all the possibilities covered. I remember IBM asking
> me about the categories a long time ago. Haven't heard anything since then.

I'm at linux.conf.au this week so I probably won't have time to look at
it properly 'til next week sorry.

cheers


