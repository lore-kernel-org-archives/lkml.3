Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbaCXU5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbaCXU5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:57:32 -0400
Date: Mon, 24 Mar 2014 16:57:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, peterz@infradead.org, eranian@google.com,
        andi.kleen@intel.com
Subject: Re: [PATCH 01/15 V3] perf: Fix stddev calculation
Message-ID: <20140324205705.GE25953@redhat.com>
References: <1395689676-214799-5-git-send-email-dzickus@redhat.com>
 <1395694478-220482-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395694478-220482-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 04:54:38PM -0400, Don Zickus wrote:
> The stddev calculation written matched standard error.  As a result when
> using this result to find the relative stddev between runs, it was not
> accurate.
> 

This isn't the patch I that had my updates...  Sorry for the noise.

Cheers,
Don
