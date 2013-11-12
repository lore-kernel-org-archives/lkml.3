Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3KLP4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:56:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab3KLP4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:56:09 -0500
Message-ID: <1384271711.24631.5.camel@deneb.redhat.com>
Subject: Re: [PATCH 00/11] Consolidate asm/fixmap.h files
From: Mark Salter <msalter@redhat.com>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Kuo <rkuo@codeaurora.org>, linux-hexagon@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 12 Nov 2013 10:55:11 -0500
In-Reply-To: <52824BBC.9020401@monstr.eu>
References: <1384262545-20875-1-git-send-email-msalter@redhat.com>
	 <52824BBC.9020401@monstr.eu>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 16:39 +0100, Michal Simek wrote:
> On 11/12/2013 02:22 PM, Mark Salter wrote:
> > 
> >  arch/arm/include/asm/fixmap.h        |  25 ++------
> >  arch/hexagon/include/asm/fixmap.h    |  40 +------------
> >  arch/metag/include/asm/fixmap.h      |  32 +----------
> >  arch/microblaze/include/asm/fixmap.h |  44 +-------------
> >  arch/mips/include/asm/fixmap.h       |  33 +----------
> >  arch/powerpc/include/asm/fixmap.h    |  44 +-------------
> >  arch/sh/include/asm/fixmap.h         |  39 +------------
> >  arch/tile/include/asm/fixmap.h       |  33 +----------
> >  arch/um/include/asm/fixmap.h         |  40 +------------
> >  arch/x86/include/asm/fixmap.h        |  59 +------------------
> >  include/asm-generic/fixmap.h         | 107 +++++++++++++++++++++++++++++++++++
> >  11 files changed, 125 insertions(+), 371 deletions(-)
> >  create mode 100644 include/asm-generic/fixmap.h
> 
> Any repo/branch with all these patches will be helpful.

https://github.com/mosalter/linux (fixmap branch)


