Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaEEUpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:45:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:43829 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbaEEUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:45:02 -0400
Message-ID: <5367F832.4090901@oracle.com>
Date: Mon, 05 May 2014 16:44:34 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, akpm@linuxfoundation.org
Subject: Re: fs: dcookie: freeing active timer
References: <53594244.6070305@oracle.com>	<20140424172708.GY18016@ZenIV.linux.org.uk>	<53594B16.4000901@oracle.com>	<20140424215558.GZ18016@ZenIV.linux.org.uk>	<20140424234941.GA18016@ZenIV.linux.org.uk>	<5359D70B.2070604@oracle.com>	<53616F92.4020709@oracle.com>	<alpine.DEB.2.10.1404301819140.27262@gentwo.org> <20140501131005.2aca98242477d8f98e33b19f@linux-foundation.org>
In-Reply-To: <20140501131005.2aca98242477d8f98e33b19f@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 04:10 PM, Andrew Morton wrote:
>> On Wed, 30 Apr 2014, Sasha Levin wrote:
>> > 
>>>> > > > Could someone pretty please merge that patch? Specially since Greg acked it?
>>> > >
>>> > > Ping?
>> > 
>> > Ok please repost. Andrew or Pekka can merge it.
> OK, I seem to have pieced it all together.  The changelog sucked :( I
> fixed it up a bit but I still don't see why we added that
> SLAB_SUPPORTS_SYSFS thing.  Why do slab and slub differ here?  What
> about slob?
> 
> A number of rejects had to be fixed.  Please check this over carefully.

That patch fixed the issues I've been seeing, and I'm not seeing any new
issues caused by the patch.


Thanks,
sasha
