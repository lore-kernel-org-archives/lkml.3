Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaH0K2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:28:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:12634 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933323AbaH0K2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:28:13 -0400
X-IronPort-AV: E=Sophos;i="5.04,409,1406592000"; 
   d="scan'208";a="165566990"
Message-ID: <53FDB2BA.8080506@citrix.com>
Date: Wed, 27 Aug 2014 11:28:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Matt Rushton <mvrushton@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <msw@amazon.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v3 2/2] xen/setup: Remap Xen Identity Mapped RAM
References: <1407778441-26604-1-git-send-email-mrushton@amazon.com> <1407778441-26604-2-git-send-email-mrushton@amazon.com>
In-Reply-To: <1407778441-26604-2-git-send-email-mrushton@amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/14 18:34, Matt Rushton wrote:
> Instead of ballooning up and down dom0 memory this remaps the existing mfns
> that were replaced by the identity map. The reason for this is that the
> existing implementation ballooned memory up and and down which caused dom0
> to have discontiguous pages. In some cases this resulted in the use of bounce
> buffers which reduced network I/O performance significantly. This change will
> honor the existing order of the pages with the exception of some boundary
> conditions.

Applied to devel/for-linus-3.18.

Patch #1 is already present in 3.17-rc1.

Thanks.

David
