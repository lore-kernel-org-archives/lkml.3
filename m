Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3FZVZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:25:51 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20474 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3FZVZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:25:49 -0400
Date: Wed, 26 Jun 2013 17:25:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-next@vger.kernel.org
Subject: Re: [Xen-devel] linux-next: Tree for Jun 26 (xen/x86)
Message-ID: <20130626212509.GB2810@phenom.dumpdata.com>
References: <20130626180653.57aee1721b4b5096ddc8f82d@canb.auug.org.au>
 <51CB379A.7010606@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB379A.7010606@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:48:58AM -0700, Randy Dunlap wrote:
> On 06/26/13 01:06, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130625:
> > 
> 
> CONFIG_SMP is not set
> CONFIG_X86_UP_APIC is not set

That is new. Any thoughts of which patch might be the culprit?
What are the other config options? What XEN options are set?

> 
> on i386:
> 
> drivers/built-in.o: In function `xen_callback_vector':
> (.text+0x1dc3cb): undefined reference to `first_system_vector'
> drivers/built-in.o: In function `xen_callback_vector':
> (.text+0x1dc3f5): undefined reference to `first_system_vector'
> 
> 
> -- 
> ~Randy
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
