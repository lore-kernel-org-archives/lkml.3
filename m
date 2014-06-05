Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaFEX3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:29:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:35152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaFEX3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:29:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,984,1392192000"; 
   d="scan'208";a="550493434"
Date: Thu, 5 Jun 2014 16:29:49 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Stephane Eranian <eranian@google.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605232949.GF16855@tassilo.jf.intel.com>
References: <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
 <CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
 <20140605132750.GA16811@pd.tnic>
 <CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
 <20140605140316.GB16811@pd.tnic>
 <CAHzUATiVCHytrG3sz8AmC8anZTQcPDRHp91-kWEoeq=RU7UNiw@mail.gmail.com>
 <20140605151734.GD16811@pd.tnic>
 <CAHzUATioT8e=RxypbqBsHw-QkcYsdQEiKhb3e44A4S+98Ut6=Q@mail.gmail.com>
 <20140605165213.GI16642@pd.tnic>
 <CAHzUATiOi0_U4r+TN_okYh_5_VB-NpW+A5qgg6Vkz9kyrwqZug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHzUATiOi0_U4r+TN_okYh_5_VB-NpW+A5qgg6Vkz9kyrwqZug@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As Stephane pointed out, the sysfs entry is optional and the workaround
> can be disabled only as root.
> 
> It is not absolutely necessary and it's not important.
> We will drop it in V2.

I would prefer to keep it. It's fairly complex and it's always good
to have a way to disable complex things in case something goes wrong.

-Andi
