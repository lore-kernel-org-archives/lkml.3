Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3B0XIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:08:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3B0XIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:08:52 -0500
Message-ID: <512E91B7.6060102@zytor.com>
Date: Wed, 27 Feb 2013 15:07:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        konrad.wilk@oracle.com, tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default> <512E8B41.8000504@zytor.com> <20130227230009.GA32465@kroah.com>
In-Reply-To: <20130227230009.GA32465@kroah.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 03:00 PM, Greg KH wrote:
> 
> "Stable" kernels are used all over the place, like in distros, which
> might enable this.
> 
> I have no objection to taking this patch in a stable release, as it does
> fix a real problem.
> 

OK.  I will queue it up in the next fixes (tip:x86/urgent) batch to Linus.

	-hpa


