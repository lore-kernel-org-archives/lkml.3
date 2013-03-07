Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab3CGA43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:56:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55748 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab3CGA42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:56:28 -0500
Date: Thu, 7 Mar 2013 00:52:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Paul Bolle'" <pebolle@tiscali.nl>, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: S3C24XX: drop "select MACH_N35"
Message-ID: <20130307005206.GZ17833@n2100.arm.linux.org.uk>
References: <1362609234.28137.2.camel@x61.thuisdomein> <013a01ce1ac7$11b287d0$35179770$%kim@samsung.com> <1362615081.28137.5.camel@x61.thuisdomein> <014601ce1acd$bc63d480$352b7d80$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <014601ce1acd$bc63d480$352b7d80$%kim@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 09:50:17AM +0900, Kukjin Kim wrote:
> Paul Bolle wrote:
> > 
> > On Thu, 2013-03-07 at 09:02 +0900, Kukjin Kim wrote:
> > 
> > > BTW, so the machine type can be removed at arch/arm/tools/mach-types as
> > well.
> > 
> > Well, that file has a big comment on top, containing the line:
> >     Please do not send patches to this file; it is automatically
> > generated!
> > 
> > So I didn't dare to touch it.
> > 
> Yeah, I know.
> 
> It will be handled by Russell King :-)

And deleting entries from it is pointless if they've ever been in the
kernel.
