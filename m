Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbaBRNHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbaBRNHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:07:37 -0500
Date: Tue, 18 Feb 2014 14:07:31 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 13/21] perf, c2c: Add callchain support
Message-ID: <20140218130731.GK4343@krava.brq.redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392053356-23024-14-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053356-23024-14-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:29:08PM -0500, Don Zickus wrote:
> Seeing cacheline statistics is useful by itself.  Seeing the callchain
> for these cache contentions saves time tracking things down.
> 
> This patch tries to add callchain support.  I had to use the generic
> interface from a previous patch to output things to stdout easily.
> 
> Other than the displaying the results, collecting the callchain and
> merging it was fairly straightforward.
> 
> I used a lot of copying-n-pasting from other builtin tools to get
> the intial parameter setup correctly and the automatic reading of
> 'symbol_conf.use_callchain' from the data file.
> 
> Hopefully this is all correct.  The amount of memory corruption (from the
> callchain dynamic array) seems to have dwindled done to nothing. :-)

hum.. report command already has all this.. if we could go the
hist_entry way, there'd be no need to reiplement this

jirka
