Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3CAW5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:57:42 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:39094 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3CAW5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:57:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130301.162400.1645765127882618751.davem@davemloft.net>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	<20130301.162400.1645765127882618751.davem@davemloft.net>
Date: Fri, 1 Mar 2013 14:57:40 -0800
Message-ID: <CA+mtBx8QS8Gkue6Pu8qw8v0q0zn-j1xLSZhxZ5yP=UTbJe4yaQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
From: Tom Herbert <therbert@google.com>
To: David Miller <davem@davemloft.net>
Cc: eliezer.tamir@linux.jf.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is exactly the kind of approach that makes sense rather than
> trying to put entire TCP stacks in the network card firmware.
>
And should also obviate the need to put a full TCP stack in user space!

> Thanks again for doing this work and I look forward to applying
> this stuff once all the kinks are worked out.  The folks in the
> Intel NIC group continue to impress me.
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
