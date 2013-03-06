Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3CFWXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:23:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37377 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3CFWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:23:46 -0500
Date: Wed, 6 Mar 2013 17:23:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20130306222338.GC11269@phenom.dumpdata.com>
References: <20130306113508.9c868be103b6b140295c548f@canb.auug.org.au>
 <20130306004341.GA28426@kroah.com>
 <20130306135654.GA10760@phenom.dumpdata.com>
 <20130306200444.GA13744@phenom.dumpdata.com>
 <20130307075055.a8722b275ed6edb53839e13b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307075055.a8722b275ed6edb53839e13b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 07:50:55AM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> On Wed, 6 Mar 2013 15:04:44 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >
> > So, irrespective of zcache, I also see this:
> > 
> > init/built-in.o: In function `.rd_load_image':
> > (.init.text+0x1b24): undefined reference to `.__bswapdi2'
> > arch/powerpc/kernel/built-in.o: In function `.iowa_writeq':
> > io-workarounds.c:(.text+0x2f778): undefined reference to `.__bswapdi2'
> > arch/powerpc/kernel/built-in.o: In function `.iowa_readq':
> > io-workarounds.c:(.text+0x2f848): undefined reference to `.__bswapdi2'
> > arch/powerpc/platforms/built-in.o: In function `.spiderpci_readq':
> > spider-pci.c:(.text+0x2a84c): undefined reference to `.__bswapdi2'
> > arch/powerpc/platforms/built-in.o: In function `.scc_pciex_readq':
> > celleb_scc_pciex.c:(.text+0x2fc4c): undefined reference to `.__bswapdi2'
> > fs/built-in.o:(.text+0x9717c): more undefined references to `.__bswapdi2' follow
> > 
> > Is that new?
> 
> I don't get those.  What compiler version and config are you using?

powerpc64-unknown-linux-gnu-gcc (GCC) 4.4.2

The defconfig with CONFIG_STAGING=y, CONFIG_CONFIGFS_FS=y, CONFIG_FRONTSWAP=y and CONFIG_ZCACHE_* =y

