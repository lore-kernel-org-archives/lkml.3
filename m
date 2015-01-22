Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbbAVFT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:19:27 -0500
Received: from ozlabs.org ([103.22.144.67]:33848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbbAVFTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:19:20 -0500
Message-ID: <1421903958.4598.4.camel@ellerman.id.au>
Subject: Re: [PATCH v2 2/2] powerpc/powernv: Skip registering log region
 when CONFIG_PRINTK=n
From: Michael Ellerman <mpe@ellerman.id.au>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        Rob Herring <robh@kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Thu, 22 Jan 2015 16:19:18 +1100
In-Reply-To: <1421893570-6920-2-git-send-email-bobby.prani@gmail.com>
References: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
	 <1421893570-6920-2-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 21:26 -0500, Pranith Kumar wrote:
> When CONFIG_PRINTK=n, log_buf_addr_get() returns NULL and log_buf_len_get()
> return 0. Check for these return values and skip registering the dump buffer.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  arch/powerpc/platforms/powernv/opal.c | 6 ++++++
>  1 file changed, 6 insertions(+)

What changed since v1? I don't see anything?

cheers


