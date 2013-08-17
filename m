Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3HQMao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 08:30:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917Ab3HQMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 08:30:42 -0400
Date: Sat, 17 Aug 2013 13:30:39 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] dm: Make MIN_IOS, et al, tunable via sysctl.
Message-ID: <20130817123039.GR1762@agk-dp.fab.redhat.com>
Mail-Followup-To: Frank Mayhar <fmayhar@google.com>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 03:55:21PM -0700, Frank Mayhar wrote:
> This patch fixes that by changing the hardcoded MIN_IOS (and certain
> other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> sysctl-modifiable values.  This lets us change the size of these pools
> on the fly, we can reduce the size of the pools and reduce memory
> pressure.
 
Did you consider using module_param_named()?
(E.g. dm_verity_prefetch_cluster in dm-verity.)

Alasdair

