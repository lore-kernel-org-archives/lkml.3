Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3HEIfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068Ab3HEIfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:35:30 -0400
Date: Mon, 5 Aug 2013 10:35:23 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf x86: Fix compile of util/tsc.c
Message-ID: <20130805083523.GB18719@krava.redhat.com>
References: <1374848843-43127-1-git-send-email-dsahern@gmail.com>
 <51FF63B1.4070808@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51FF63B1.4070808@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 11:34:57AM +0300, Adrian Hunter wrote:
> On 26/07/13 17:27, David Ahern wrote:
> > On Fedora 18, with gcc 4.6.4 compile fails with:
> > 
> > arch/x86/util/tsc.c: In function ‘perf_time_to_tsc’:
> > arch/x86/util/tsc.c:13:6: error: declaration of ‘time’ shadows a global declaration [-Werror=shadow]
> > cc1: all warnings being treated as errors
> > make: *** [/tmp/junk/arch/x86/util/tsc.o] Error 1
> > make: *** Waiting for unfinished jobs....
> > 
> > Fix by renaming the local variable.
> > 
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> > Cc: Adrian Hunter <adrian.hunter@intel.com>
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>
