Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab3EaJ4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:56:18 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:24983 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3EaJ4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:56:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,778,1363132800"; 
   d="scan'208";a="27124112"
Message-ID: <51A873B9.4000407@citrix.com>
Date: Fri, 31 May 2013 10:56:09 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <xen-devel@lists.xen.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv3 0/2] xen: maintain an accurate persistent clock in more
 cases
References: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com> <51A7E709.9080309@linaro.org>
In-Reply-To: <51A7E709.9080309@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/13 00:55, John Stultz wrote:
> On 05/30/2013 07:25 AM, David Vrabel wrote:
>> 
>> These series fixes the above limitations and depends on "x86: increase
>> precision of x86_platform.get/set_wallclock()" which was previously
>> posted.
> 
> This is the only area that will need some coordination cross the Xen
> tree and tip/timers/core (once that patch and the fix for it I have
> queued lands in -tip). The options here are:
> 
> * I queue these two patches with proper Xen maintainer's acks/review

I'm happy for this to be queues for 3.11.  Although the series does fix
a bug it's one that I don't think affects that many people (I don't
think I seen any bug reports from anyone else).

We're only rarely seeing the problem in our automated test system which
is not a typical setup.

David
