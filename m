Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3CWXNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 19:13:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3CWXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 19:13:39 -0400
Message-ID: <514E3711.8020609@oracle.com>
Date: Sat, 23 Mar 2013 19:13:21 -0400
From: konrad wilk <konrad.wilk@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.9-rc3-tag
References: <20130322210201.GA7932@phenom.dumpdata.com> <alpine.DEB.2.02.1303231705170.5135@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1303231705170.5135@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > David Vrabel (1): xen/events: avoid race with raising an event in 
unmask_evtchn()
> Unless I am looking in the wrong place, this patch is still the same one
> that breaks PV on HVM and Xen ARM guests, see:
>
> http://marc.info/?l=xen-devel&m=136377731913034
>
> David is aware of the issue and I think is working on an alternative
> fix.

Thank you for noticing that. Linus does not look to have pulled it - so 
we still have some time
to fix this right.
