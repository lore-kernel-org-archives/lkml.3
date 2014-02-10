Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBJTRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:17:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBJTRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:17:33 -0500
Date: Mon, 10 Feb 2014 14:17:18 -0500
From: Don Zickus <dzickus@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140210191718.GE25953@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
 <1392058770.1099.37.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392058770.1099.37.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:59:30AM -0800, Davidlohr Bueso wrote:
> This can be really useful for us performance folks, thanks. It seems
> however that the first two patches in the series are missing.

Odd, yes.  For some reason they cc'd to me fine, just never made it to
lkml.  Let me resend them. Thanks.

Cheers,
Don
