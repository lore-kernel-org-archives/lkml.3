Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3HVFoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:44:23 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:51414 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3HVFoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:44:21 -0400
Date: Thu, 22 Aug 2013 09:44:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>, Xen-devel@lists.xen.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pavel Emelyanov <xemul@parallels.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dhillf@gmail.com
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
Message-ID: <20130822054418.GE18673@moon>
References: <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
 <5214F128.1000901@citrix.com>
 <20130821172547.GY18673@moon>
 <20130821181733.GC3814@moon>
 <4fec3e5b-695c-438b-ad6d-55ca50becc4c@email.android.com>
 <20130821190307.GB18673@moon>
 <CA+55aFw_tWio_ABFUocNHU+_RKe-27U9_=4ATfp3-vSWVZkdug@mail.gmail.com>
 <20130822005115.GA1188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822005115.GA1188@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:51:15PM -0400, Dave Jones wrote:
> 
> Could this explain what I'm seeing in another thread ?
> https://lkml.org/lkml/2013/8/7/27

Don't think so. This code is merged in -rc6, while your report is saying the
kernel version is -rc4 (also this feature requires CONFIG_MEM_SOFT_DIRTY
to be turned on, do you have it?).
