Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaFEK14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:27:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:50619 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaFEK1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:27:54 -0400
Message-ID: <1401964037.3247.129.camel@pasglop>
Subject: Re: [PATCH 3/3] PPC: KVM: Add support for 64bit TCE windows
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Date: Thu, 05 Jun 2014 20:27:17 +1000
In-Reply-To: <539037DB.5080706@ozlabs.ru>
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
	 <1401953144-19186-4-git-send-email-aik@ozlabs.ru>
	 <1401953908.3247.121.camel@pasglop> <539037DB.5080706@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 19:26 +1000, Alexey Kardashevskiy wrote:
> 
> No trees yet. For 64GB window we need (64<<30)/(16<<20)*8 = 32K TCE table.
> Do we really need trees?

The above is assuming hugetlbfs backed guests. These are the least of my worry
indeed. But we need to deal with 4k and 64k guests.

Cheers,
Ben


