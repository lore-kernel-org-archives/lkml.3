Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773Ab3KMSan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:30:43 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45612 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736Ab3KMSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:30:36 -0500
Date: Wed, 13 Nov 2013 19:30:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf tip: fails to convert comm
Message-ID: <20131113183031.GC28039@localhost.localdomain>
References: <528306F5.8050307@gmail.com>
 <20131113180344.GA28039@localhost.localdomain>
 <5283BF93.80603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5283BF93.80603@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:06:11AM -0700, David Ahern wrote:
> On 11/13/13, 11:03 AM, Frederic Weisbecker wrote:
> >I see. I can reproduce, I'll check and see what happens. It would be nice if
> >we could have an option to dump internal perf events like comm events as well
> >in the perf script stream.
> 
> I've been thinking about moving the event dumping code from
> perf-script to perf-dump. In the process could add an argument to
> dump events -- similar to -D option for report/script, but more
> inline with the output that perf-script shows now.

Yeah indeed,sounds good!
