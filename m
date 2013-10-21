Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3JUKSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab3JUKSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:18:10 -0400
Date: Mon, 21 Oct 2013 12:19:51 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        Mark Lord <kernel@start.ca>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 29/29] vmxnet3: Make use of
 pcim_enable_msix_range() interface
Message-ID: <20131021101951.GA4221@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <75788c5da384b16633fdab43d37a277aa92f38fd.1382103786.git.agordeev@redhat.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7398@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7398@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 09:51:32AM +0100, David Laight wrote:
> > Subject: [PATCH RFC v2 29/29] vmxnet3: Make use of pcim_enable_msix_range() interface
> AFAICT the old code either used the requested number or the minimum number.
> The new code seems to claim an intermediate number of interrupts - but probably
> only uses the minimum number.

Yes, you are right. I missed the vectors = vector_threshold assignment.
This driver is inapplicable as an example.


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
