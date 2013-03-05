Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab3CEUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:03:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371Ab3CEUDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:47 -0500
Message-ID: <51364F76.4060107@zytor.com>
Date: Tue, 05 Mar 2013 12:03:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: bhutchings@solarflare.com, eliezer.tamir@linux.jf.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, andi@firstfloor.org, eliezer@tamir.org.il
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com> <20130227175555.10611.42794.stgit@gitlad.jf.intel.com> <1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com> <20130305.145524.1486936679665458305.davem@davemloft.net>
In-Reply-To: <20130305.145524.1486936679665458305.davem@davemloft.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 11:55 AM, David Miller wrote:
> From: Ben Hutchings <bhutchings@solarflare.com>
> Date: Tue, 5 Mar 2013 16:43:01 +0000
> 
>> In general it appears to require a run-time check.  You might need to
>> augment <asm/timex.h>.
> 
> On the other hand, unlike get_cycles, sched_clock() is always available.
> 

On the gripping hand, we need to know when it uses something like
jiffies, in which case we probably need to disable the whole interface.

	-hpa

