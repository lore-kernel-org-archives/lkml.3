Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3BDHbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:31:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3BDHbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:31:04 -0500
Date: Mon, 4 Feb 2013 08:30:27 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
Message-ID: <20130204073027.GA15987@krava.redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
 <1359230650-10415-2-git-send-email-jolsa@redhat.com>
 <CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
 <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
 <20130129080305.GB594@gmail.com>
 <CABPqkBSVnbt1pthyW2au1Wnpvvf+8Acf2MjCwNLf8Hvw88j4Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSVnbt1pthyW2au1Wnpvvf+8Acf2MjCwNLf8Hvw88j4Aw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 09:37:16PM +0100, Stephane Eranian wrote:
> On Tue, Jan 29, 2013 at 9:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> On Mon, Jan 28, 2013 at 9:52 PM, Stephane Eranian <eranian@google.com> wrote:

SNIP

> Adding the option for users to link with libpfm4 was no big
> deal in my mind. You are opposed to that. That's your
> choice. I don't buy your arguments for this patch series
> and will continue to provide a patch to link perf and libpfm4
> for users who are interested.
> 
> I would have appreciated some discussion on this instead, once
> again, work was done behind closed door and thrown at my face.

Not sure why you think it was 'closed door'.. I needed some way to
access those events and sent RFC for it with you being on CC list.

> The worst being that as far I can see in the patches, no proper
> credits to libpfm4 contributors is even given for providing the raw
> information that allowed you to  build your event tables without too

Right, sorry for that.. I'll add it.

> much sweat! Building electronic event tables from vendor specs is
> a lot harder than it seems, but you may not know this.

jirka
