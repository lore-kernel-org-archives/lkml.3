Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3B1QUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:20:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17428 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3B1QUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:20:46 -0500
Message-ID: <512F83C4.6080904@oracle.com>
Date: Thu, 28 Feb 2013 11:20:20 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Re: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was:
 Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default> <512E8B41.8000504@zytor.com> <20130227230009.GA32465@kroah.com> <512E91B7.6060102@zytor.com> <20130228142910.GA32354@phenom.dumpdata.com> <20130228153846.GA9782@pd.tnic> <512F7D88.4090703@zytor.com> <20130228161057.GC9767@pd.tnic>
In-Reply-To: <20130228161057.GC9767@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 11:10 AM, Borislav Petkov wrote:
> On Thu, Feb 28, 2013 at 07:53:44AM -0800, H. Peter Anvin wrote:
>> At the very least we should have an early filter for the **COMMON!**
>> case that we are not on a PV platform.
> ... or, patch it out with the alternatives on baremetal, as Steven
> suggested.
>

I think making a check for paravirt_enabled() is safe enough. I'll send 
a patch shortly.

-boris
