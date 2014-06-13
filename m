Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaFMN3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:29:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29639 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaFMN3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:29:50 -0400
Message-ID: <539AFCBF.1040505@oracle.com>
Date: Fri, 13 Jun 2014 09:29:35 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mm/fs: gpf when shrinking slab
References: <539AF460.4000400@oracle.com> <539AF4A6.9060707@oracle.com> <20140613130026.GF18016@ZenIV.linux.org.uk>
In-Reply-To: <20140613130026.GF18016@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 09:00 AM, Al Viro wrote:
> On Fri, Jun 13, 2014 at 08:55:02AM -0400, Sasha Levin wrote:
>> Hand too fast on the trigger... sorry.
>>
>> It happened while fuzzing inside a KVM tools guest on the latest -next kernel. Seems
>> to be pretty difficult to reproduce.
> 
> Does that kernel contain c2338f?
> 

Nope, it didn't.


Thanks,
Sasha
