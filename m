Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaEVFaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:30:09 -0400
Received: from ozlabs.org ([103.22.144.67]:45902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaEVFaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:30:07 -0400
Message-ID: <1400736606.14864.11.camel@concordia>
Subject: Re: [PATCH V2 2/3] powerpc, ptrace: Enable support for
 transactional memory register sets
From: Michael Ellerman <mpe@ellerman.id.au>
To: Pedro Alves <palves@redhat.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, mikey@neuling.org, avagin@openvz.org,
        oleg@redhat.com, Roland McGrath <roland@hack.frob.com>
Date: Thu, 22 May 2014 15:30:06 +1000
In-Reply-To: <5372547D.8040209@redhat.com>
References: <1399276469-13541-1-git-send-email-khandual@linux.vnet.ibm.com>
	 <1399276469-13541-3-git-send-email-khandual@linux.vnet.ibm.com>
	 <5372547D.8040209@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 18:21 +0100, Pedro Alves wrote:
> I wonder whether people are getting Roland's address from?
> 
> It's frequent that ptrace related patches end up CCed to
> roland@redhat.com, but, he's not been at Red Hat for a few years
> now.  Roland, do you still want to be CCed on ptrace-related
> issues?  If so, there's probably a script somewhere in the
> kernel that needs updating.  If not, well, it'd be good
> if it were updated anyway.  :-)

In MAINTAINERS I see:

PTRACE SUPPORT
M:	Roland McGrath <roland@redhat.com>
M:	Oleg Nesterov <oleg@redhat.com>
S:	Maintained


cheers


