Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3KUDdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 22:33:38 -0500
Received: from ozlabs.org ([203.10.76.45]:41076 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3KUDdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 22:33:35 -0500
Date: Thu, 21 Nov 2013 14:33:34 +1100
From: Anton Blanchard <anton@samba.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (Linus'
 tree related - powerpc)
Message-ID: <20131121143334.44be4231@kryten>
In-Reply-To: <20131121134622.a853064a1b5a8355e5077737@canb.auug.org.au>
References: <20131121134622.a853064a1b5a8355e5077737@canb.auug.org.au>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> <stdin>:1:0: error: -mcall-aixdesc must be big endian

Urgh, allyesconfig is building an LE kernel. Ian: do we need to reverse
the polarity of the option, and call it CONFIG_CPU_BIG_ENDIAN?

Anton
