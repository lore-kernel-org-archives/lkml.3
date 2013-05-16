Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3EPTRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:17:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3EPTRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:17:17 -0400
Date: Thu, 16 May 2013 15:17:01 -0400
From: Dave Jones <davej@redhat.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: net: cdc_ncm, cdc_mbim: allow user to prefer NCM for backwards
 compatibility
Message-ID: <20130516191701.GC5805@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	Ben Hutchings <ben@decadent.org.uk>
References: <20130516182510.GA4728@redhat.com>
 <87mwrueo9k.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mwrueo9k.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 09:08:23PM +0200, Bjørn Mork wrote:
 > Yes, this is a very unfortunate side effect of the userspace/kernel
 > split of the MBIM driver combined with the NCM/MBIM "backwards
 > compatibility" setting.  Which in itself is a bad idea, IMHO.
 > 
 > I recommend all distros do the same as Debian: Set NCM as default until
 > a userspace application with MBIM support is ready and packaged in the
 > distro:
 > http://anonscm.debian.org/viewvc/kernel/dists/trunk/linux/debian/patches/debian/cdc_ncm-cdc_mbim-use-ncm-by-default.patch

Thanks for the pointer. We'll pick that up for the Fedora 3.9 kernels.

Ben, does debian have a commits mailing list for kernel changes ?

 > FWIW, I wish we would have thought about this issue before v3.8 was
 > released.  Then we could have made that patch the mainline default,
 > without that being a userspace API change.  But we didn't.
 > 
 > The good news is that Aleksander has done some nice work on the MBIM
 > support in ModemManager, so there is a good chance that the next release
 > will make this problem go away.

good news indeed!

thanks.

	Dave

