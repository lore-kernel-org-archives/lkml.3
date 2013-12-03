Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3LCQGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:06:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7714 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3LCQGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:06:16 -0500
X-IronPort-AV: E=Sophos;i="4.93,818,1378857600"; 
   d="scan'208";a="77783915"
Message-ID: <1386086771.13256.57.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Date: Tue, 3 Dec 2013 16:06:11 +0000
In-Reply-To: <20131203155153.2b5488d2@alan.etchedpixels.co.uk>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
	 <529DBA07.6090108@citrix.com>
	 <1386068884.13256.9.camel@kazak.uk.xensource.com>
	 <529DC7BA.7080506@citrix.com>
	 <1386078108.13256.30.camel@kazak.uk.xensource.com>
	 <529DF4A0.50103@citrix.com>
	 <1386083821.13256.42.camel@kazak.uk.xensource.com>
	 <20131203155153.2b5488d2@alan.etchedpixels.co.uk>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 15:51 +0000, One Thousand Gnomes wrote:
> > > If Konrad and Boris agree that breaking the kernel's ABI in this way is
> > > acceptable in this specific case, I'll defer to them.
> > 
> > My opinion as Xen on ARM hypervisor maintainer is that this is the right
> > thing to do in this case.
> 
> Sounds to me like the difference between "product" and "research toy".
> You don't break back compatibility in a product when you can avoid it.
> You may wish the publically humiliate those responsible (Linus seems to)
> but at the end of the day it's done.

We've been quite explicit about the fact that the ABI is not set in
stone yet. The only Xen release which included ARM support had it
explicitly marked as a tech preview and we have changed the ABI multiple
times during the development process as we worked through the kinks.

I expect that with the Xen 4.4 release this will change, and at the
point we will have to live with the ABI we've got, including
compatibility.

> Your boolean choice is a false one anyway - you can do at least three
> different things

The right thing to do here is to fix the implementation and move on.

Ian.

