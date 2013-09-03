Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760162Ab3ICOVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:21:11 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:56624 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab3ICOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:21:09 -0400
Date: Tue, 3 Sep 2013 14:21:07 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Miller <davem@davemloft.net>
cc: dhowells@redhat.com, tj@kernel.org, akpm@linuxfoundation.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        srostedt@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [guv v2 04/31] net: Replace __get_cpu_var uses
In-Reply-To: <20130902.203355.117341085023152754.davem@davemloft.net>
Message-ID: <00000140e432c014-26be929a-a2f1-4064-8147-0efcb5dc3bec-000000@email.amazonses.com>
References: <00000140bc5ef9df-d7f75909-a25e-4471-84b2-dfbec07117b0-000000@email.amazonses.com> <20130826204351.725357339@linux.com> <7435.1378157706@warthog.procyon.org.uk> <20130902.203355.117341085023152754.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.03-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013, David Miller wrote:

> It really will cache pre-computed __thread pointer calculations across
> sched().

On x86 the compiler could use the segment prefix and then it may work.

