Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3FLUej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:34:39 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52988 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab3FLUei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:34:38 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 12 Jun 2013 13:34:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: Re: [ 00/79] 3.9.6-stable review
Message-ID: <20130612203437.GA16588@roeck-us.net>
References: <20130611195312.352656079@linuxfoundation.org>
 <20130612202915.GA27379@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612202915.GA27379@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 01:29:15PM -0700, Guenter Roeck wrote:
> On Tue, Jun 11, 2013 at 01:02:26PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 3.9.6 release.
> > There are 79 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu Jun 13 19:50:17 UTC 2013.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.6-rc1.gz
> > and the diffstat can be found below.
> > 
> powerpc defconfig and as well as various other powerpc builds fail with:
> 
> arch/powerpc/platforms/pseries/msi.c: In function 'rtas_hack_32bit_msi_gen2':
> arch/powerpc/platforms/pseries/msi.c:408:34: error: 'struct pci_dev' has no member named 'msi_cap'
> arch/powerpc/platforms/pseries/msi.c:410:35: error: 'struct pci_dev' has no member named 'msi_cap'
> arch/powerpc/platforms/pseries/msi.c:411:35: error: 'struct pci_dev' has no member named 'msi_cap'
> 
> Introduced by commit 7b58b0edaa2 (powerpc/pseries: Make 32-bit MSI quirk work
> on systems lacking firmware support).
> 
s/7b58b0edaa2/f1dd153121/

7b58b0edaa2 is from my git branch and won't help much.

Guenter
