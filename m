Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3CYOMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 10:12:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:3481 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab3CYOMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 10:12:46 -0400
X-IronPort-AV: E=Sophos;i="4.84,905,1355097600"; 
   d="scan'208";a="15358970"
Message-ID: <51505B5C.5050408@citrix.com>
Date: Mon, 25 Mar 2013 14:12:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: konrad wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.9-rc3-tag
References: <20130322210201.GA7932@phenom.dumpdata.com> <alpine.DEB.2.02.1303231705170.5135@kaball.uk.xensource.com> <514E3711.8020609@oracle.com>
In-Reply-To: <514E3711.8020609@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/13 23:13, konrad wilk wrote:
>  > David Vrabel (1): xen/events: avoid race with raising an event in 
> unmask_evtchn()
>> Unless I am looking in the wrong place, this patch is still the same one
>> that breaks PV on HVM and Xen ARM guests, see:
>>
>> http://marc.info/?l=xen-devel&m=136377731913034
>>
>> David is aware of the issue and I think is working on an alternative
>> fix.
> 
> Thank you for noticing that. Linus does not look to have pulled it - so 
> we still have some time
> to fix this right.

Konrad,

I've just posted an updated version of this patch.  I'd suggest waiting
for an ack from Stefano before applying it.

David

