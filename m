Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3LCP6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:58:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53244 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab3LCP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:58:34 -0500
Date: Tue, 3 Dec 2013 15:55:47 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Julien Grall <julien.grall@linaro.org>, Jan Beulich <JBeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <patches@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/block: Correctly define structures in
 public headers on ARM32 and ARM64
Message-ID: <20131203155547.669b8627@alan.etchedpixels.co.uk>
In-Reply-To: <1386085745.13256.51.camel@kazak.uk.xensource.com>
References: <1386083382-7306-1-git-send-email-julien.grall@linaro.org>
	<529E039A02000078001097F5@nat28.tlf.novell.com>
	<529DF897.1080303@linaro.org>
	<1386085745.13256.51.camel@kazak.uk.xensource.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a random thought but what about using the CONFIG_$ARCH to define a
> more semantic name, like HAVE_4_BYTE_ALIGNED_QUAD_WORDS, or whichever
> terminology for an 8-byte type is appropriate in the context.
> 
> Maybe Linux even already has such a #define?

It doesn't need one. It's written in GNU C so we have __alignof__.

See

http://gcc.gnu.org/onlinedocs/gcc/Alignment.html

