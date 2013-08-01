Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3HAJ0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:26:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:47185 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3HAJ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:26:31 -0400
Message-ID: <1375349184.3743.73.camel@pasglop>
Subject: Re: [PATCH 0/2] drivers/crypto/nx: fixes when input data is too
 large
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Date: Thu, 01 Aug 2013 19:26:24 +1000
In-Reply-To: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
References: <1374858488-24658-1-git-send-email-mhcerri@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-26 at 14:08 -0300, Marcelo Cerri wrote:
> This series of patches fixes two bugs that are triggered when the input data is
> too large. The first one is caused by the miscalculation of physical addresses
> and the second one by some limits that the co-processor has to the input data.

BTW. Are these supposed to go upstream via my tree or via crypto ?

They are not part of my latest pull request to Linus because they were
not CC'ed to linuxppc-dev so I didn't see them while collecting patches
from patchwork.

If you intend to have them go via the crypto tree that's fine, but if
you intend to have them go via powerpc, then please resend with the
correct mailing list on CC.

Cheers,
Ben.

> Marcelo Cerri (2):
>   drivers/crypto/nx: fix physical addresses added to sg lists
>   drivers/crypto/nx: fix limits to sg lists for SHA-2
> 
>  drivers/crypto/nx/nx-sha256.c | 108 +++++++++++++++++++++++-----------------
>  drivers/crypto/nx/nx-sha512.c | 113 ++++++++++++++++++++++++------------------
>  drivers/crypto/nx/nx.c        |  22 ++++++--
>  3 files changed, 148 insertions(+), 95 deletions(-)
> 


