Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3GKM46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:56:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:51187 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3GKM4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:56:55 -0400
Message-ID: <1373547392.19894.100.camel@pasglop>
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel
 handling
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Graf <agraf@suse.de>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 11 Jul 2013 22:56:32 +1000
In-Reply-To: <B526C260-1ADB-4B9F-B80A-46E5A9E53FF6@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>
	 <1373123227-22969-9-git-send-email-aik@ozlabs.ru>
	 <51DC4923.5010501@suse.de> <51DE7377.1060503@ozlabs.ru>
	 <902F79B9-BB81-40A0-865D-94E7108DAC5E@suse.de>
	 <1373546233.19894.85.camel@pasglop>
	 <B526C260-1ADB-4B9F-B80A-46E5A9E53FF6@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 14:50 +0200, Alexander Graf wrote:
> > Not really no. But that would do. You could have give a more useful
> > answer in the first place though rather than stringing him along.
> 
> Sorry, I figured it was obvious.

It wasn't no, because of the mess with modules and the nasty Makefile we
have in there. Even I had to scratch my head for a bit :-)

Ben.


