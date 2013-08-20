Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3HTRZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:25:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3HTRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:25:29 -0400
Message-ID: <5213A677.4030203@infradead.org>
Date: Tue, 20 Aug 2013 10:25:11 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] docs: Document soft dirty behaviour for freshly created
 memory regions
References: <20130820153132.GK18673@moon> <5213A002.7020408@infradead.org> <20130820170105.GM18673@moon>
In-Reply-To: <20130820170105.GM18673@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/13 10:01, Cyrill Gorcunov wrote:
> On Tue, Aug 20, 2013 at 09:57:38AM -0700, Randy Dunlap wrote:
>>>  
>>> +  While in most cases tracking memory changes by #PF-s is more than enough
>>                                                                        enough,
> 
> ?

Long introductory phrases usually merit a comma after them.

> 
> For the rest -- thanks a LOT Randy, I'll update.
> --



-- 
~Randy
