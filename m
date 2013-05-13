Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3EMJlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab3EMJlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:41:17 -0400
Date: Mon, 13 May 2013 12:40:43 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] perf: kvm live mode
Message-ID: <20130513094043.GN10830@redhat.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
 <518B9C44.7090404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518B9C44.7090404@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 08:53:24PM +0800, Xiao Guangrong wrote:
> CC kvm list.
> 
> On 05/09/2013 12:31 PM, David Ahern wrote:
> > With the consolidation of the open counters code in December 2012
> > (late to the party figuring that out) I think all of the past
> > comments on the live mode for perf-kvm have been resolved.
> 
> Great work, David! I am playing it and glad to see it works fine.
> Will review the patches later.
> 
Looks very useful indeed!

--
			Gleb.
