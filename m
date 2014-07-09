Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaGIEID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:08:03 -0400
Received: from one.firstfloor.org ([193.170.194.197]:37279 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaGIEIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:08:01 -0400
Date: Wed, 9 Jul 2014 06:07:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/9] perf, tools: Automatically look for event file
 name for cpu v3
Message-ID: <20140709040759.GL18735@two.firstfloor.org>
References: <1402700580-26939-1-git-send-email-andi@firstfloor.org>
 <1402700580-26939-5-git-send-email-andi@firstfloor.org>
 <20140709021312.GA25311@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709021312.GA25311@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is EVENTMAP a new environment variable ? If specific to PERF, should
> we prefix it with "PERF_" to avoid collision?

It's not perf specific, but shared with other tools (e.g. pmu-tools)
> 
> Would all/many architectures need this "-core" suffix or is that Intel
> specific ?

You don't need it, just specify a full name.

> Is the intent that architectures that don't need this should simply
> never set EVENTMAP variable ?

Any architecture can use EVENTMAP, it just points to a json file.

-Andi

