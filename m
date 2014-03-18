Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaCRSxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:53:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52539 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486AbaCRSxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:53:21 -0400
Message-ID: <53288FF5.3010001@zytor.com>
Date: Tue, 18 Mar 2014 11:27:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sarah Newman <srn@prgmr.com>, George Dunlap <george.dunlap@eu.citrix.com>,
        Jan Beulich <JBeulich@suse.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>	<531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com>	<53266841.6090308@prgmr.com>	<1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>	<CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>	<5327291D.60009@zytor.com>	<532739810200007800124E85@nat28.tlf.novell.com> <53272D79.5050605@eu.citrix.com> <53288DD1.9060809@prgmr.com>
In-Reply-To: <53288DD1.9060809@prgmr.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 11:17 AM, Sarah Newman wrote:
> 
> Should or has there been a review of the current xen PVABI to look for any other such deviations?
> 

It would be a very good thing to do.  First of all, the PVABI needs to
be **documented** because without that there is no hope.  I would like
to specifically call out the efforts of Konrad Wilk in this general
area, but he obviously doesn't scale, either...

The other aspect is to get rid of as much of the PVABI as possible.  HPV
is a big step in that direction, getting rid of some of the most
invasive hooks, but I think we can minimize further.

	-hpa

