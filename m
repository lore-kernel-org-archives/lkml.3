Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaENFBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:01:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:64606 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694AbaENFA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:00:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1049,1389772800"; 
   d="scan'208";a="431845357"
Date: Tue, 13 May 2014 22:00:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@infradead.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        jolsa@redhat.com
Subject: Re: [PATCH 1/9] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140514050031.GY19657@tassilo.jf.intel.com>
References: <1399935074-25167-1-git-send-email-andi@firstfloor.org>
 <1399935074-25167-2-git-send-email-andi@firstfloor.org>
 <878uq5m47b.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878uq5m47b.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:25:44PM +0900, Namhyung Kim wrote:
> Hi Andi,
> 
> On Mon, 12 May 2014 15:51:06 -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > I need a JSON parser. This adds the simplest JSON
> > parser I could find -- Serge Zaitsev's jsmn `jasmine' --
> > to the perf library. I merely converted it to (mostly)
> > Linux style and added support for non 0 terminated input.
> 
> It seems like the original code now also supports it.

Sorry I don't want to fork this code.

I think we're better of staying near upstream than trying
to fix all those (unimportant) nit-picks.

Please only point out real errors. Also the code is intentionally
not trying to have a lot of dependencies on perf infrastructure.

-Andi
