Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaIVVVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:21:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaIVVVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:21:12 -0400
Date: Mon, 22 Sep 2014 23:21:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
Subject: Re: [PATCH] sched: Remove nested extern
Message-ID: <20140922212105.GD3128@worktop.programming.kicks-ass.net>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
 <20140922190128.GA2805@worktop.programming.kicks-ass.net>
 <D428C53D-F663-4846-ACAB-74922033B048@intel.com>
 <20140922200527.GA3128@worktop.programming.kicks-ass.net>
 <D3423D3A-814F-4E22-A84B-61D76D137A98@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D3423D3A-814F-4E22-A84B-61D76D137A98@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 08:59:32PM +0000, Rustad, Mark D wrote:
> Because I have found that enabling many warnings helps identify problems
> in code and it has been my standard practice since about 1999 to do so.
> The compiler warnings are really just another form of static analysis,
> and I use it routinely on every compile. Here is how routinely: I have
> W=1 in my environment, W=12 is just too painful. I would change that
> default to W=12 if it wasn't insane to do so.

Many warnings are just plain insane and stupid. They're not helping
anybody. There's a very good reason many are disabled. I'm sure you can
find some entertaining discussions on the topic if you search the LKML
archives.
