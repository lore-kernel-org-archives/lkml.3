Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071Ab3EBSQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:16:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab3EBSQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:16:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH, RFC 18/22] Xen: SWIOTLB is only used on x86
Date: Thu, 2 May 2013 20:16:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <alpine.DEB.2.02.1305021638100.5398@kaball.uk.xensource.com> <20130502181309.GA23642@phenom.dumpdata.com>
In-Reply-To: <20130502181309.GA23642@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305022016.03332.arnd@arndb.de>
X-Provags-ID: V02:K0:9ixjB8MSL4VUUSNuGQNfBVQrGs6GCkRhutZqC1YRMeF
 zn18Z7gzdy1HKXAcILp9103C/HDXfHxSUFhyAO/szESd3MtOYg
 Lto3kyLapUZi1JUChtqSXw3ukP/CXEF1G0+hHWs+cua/4wU5Mt
 wUDWherdQcEa4k1EPhVxJnE0zIhGjUIRp1Nv5UMXwC1XHQKrQF
 cl4FgjQO22g5BRJEIhVAOTJbfcXWeykNjPtvuJIJEwAClSu8Jv
 VABY0X3V39gZ5b9iSAiwYXuMXq2qYEzQaH2WP9KFu53N154Io9
 CAgIDqfdie844Ak8CodiAubh3wWzPWuLZZOkz5MiF3voSXkjQt
 zAJKGC9SfWCoHFDYQHVI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 May 2013, Konrad Rzeszutek Wilk wrote:
> On Thu, May 02, 2013 at 04:38:50PM +0100, Stefano Stabellini wrote:
> > On Thu, 2 May 2013, Arnd Bergmann wrote:
> > > Enabling SWIOTLB_XEN on ARM results in build errors because the
> > > underlying SWIOTLB is only available on X86:
> > > 
> > > drivers/xen/swiotlb-xen.c: In function 'is_xen_swiotlb_buffer':
> > > drivers/xen/swiotlb-xen.c:105:2: error: implicit declaration of function 'mfn_to_local_pfn
> > > 
> > > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Acked as well. Should I pull this in or Arnd are you OK with taking
> with my our Acks?

I'd prefer you to take it through your tree.

Thanks,

	Arnd
