Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3LQCV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 21:21:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64100 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751954Ab3LQCV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 21:21:57 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nigel Cunningham <nigel@nigelcunningham.com.au>
Cc: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system is frozen
Date: Tue, 17 Dec 2013 03:35:14 +0100
Message-ID: <8067325.5UvABaxqIZ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52ACCBE0.5060404@nigelcunningham.com.au>
References: <20131213174932.GA27070@htj.dyndns.org> <20131214203652.GC4020@htj.dyndns.org> <52ACCBE0.5060404@nigelcunningham.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 15, 2013 08:21:36 AM Nigel Cunningham wrote:
> Hi.
> 
> On 15/12/13 07:36, Tejun Heo wrote:
> > On Sat, Dec 14, 2013 at 03:31:21PM -0500, Tejun Heo wrote:
> >> So, all this is about hibernation?  Does that mean that it's safe to
> >> unfreeze before invoking resume?  ie. we currently do,
> >>
> >> 	freeze
> >> 	suspend devs
> >> 	resume devs
> >> 	unfreeze
> >>
> >> If we can just do,
> >>
> >> 	freeze
> >> 	suspend devs
> >> 	unfreeze
> >> 	resume devs
> > Ummm... even better, does that mean, in the long term, we can decouple
> > freezing and device pm operations?  If this is just about hibernation,
> > there's no reason to wrap device driver pm ops with freezer, right?
> >
> > Thanks.
> >
> Rafael has spent far more time than me thinking about the semantics 
> here, so I'd like to defer to him. Rafael?...

Please see my reply to Tejun.

Thanks,
Rafael

