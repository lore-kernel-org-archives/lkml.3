Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaGaOne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:43:34 -0400
Received: from mail.kernel.org ([198.145.19.201]:51322 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaGaOnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:43:33 -0400
Date: Thu, 31 Jul 2014 11:43:29 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH/RFC] KVM: perf/stat: Properly show submicrosecond times
Message-ID: <20140731144329.GB20547@kernel.org>
References: <1406805231-10675-1-git-send-email-borntraeger@de.ibm.com>
 <1406805231-10675-2-git-send-email-borntraeger@de.ibm.com>
 <53DA5183.9000305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DA5183.9000305@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 31, 2014 at 08:24:03AM -0600, David Ahern escreveu:
> On 7/31/14, 5:13 AM, Christian Borntraeger wrote:
> >For lots of exits the min time (and sometimes max) is 0 or 1. Lets
> >increase the accurancy similar to what the average field alread does.
> 
> Seems reasonable to me.
> 
> Acked-by: David Ahern <dsahern@gmail.com>

Thanks, applied.

- Arnaldo
