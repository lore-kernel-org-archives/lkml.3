Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3H3Pn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 11:43:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:34614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab3H3Pn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 11:43:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,991,1367996400"; 
   d="scan'208";a="394579473"
Message-ID: <5220BDBC.2060807@linux.intel.com>
Date: Fri, 30 Aug 2013 08:43:56 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        jingbai.ma@hp.com
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6> <521F5297.4070906@linux.intel.com> <521FDE8D.4040807@jp.fujitsu.com>
In-Reply-To: <521FDE8D.4040807@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 04:51 PM, HATAYAMA Daisuke wrote:
> 
> This is not a regression just as Eric explains.
> 
> There is also my explanation in the description of the 2nd patch. I
> should have described so here explicitly.
> 

OK.  We're probably days away from a merge window, so I would like to
put this in the queue for 3.13.

	-hpa

