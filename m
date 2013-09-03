Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab3ICO1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:27:13 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:48778 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760029Ab3ICO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:27:11 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 10:27:11 EDT
Date: Tue, 3 Sep 2013 14:20:08 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Howells <dhowells@redhat.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [guv v2 04/31] net: Replace __get_cpu_var uses
In-Reply-To: <7435.1378157706@warthog.procyon.org.uk>
Message-ID: <00000140e431ded7-d71fb5bf-5a5c-418f-83e5-0e6e2f2fea9d-000000@email.amazonses.com>
References: <00000140bc5ef9df-d7f75909-a25e-4471-84b2-dfbec07117b0-000000@email.amazonses.com> <20130826204351.725357339@linux.com> <7435.1378157706@warthog.procyon.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.03-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013, David Howells wrote:

> Would it be possible to use __thread annotations for per-CPU variables, I
> wonder?

We already have a __percpu annotation. Looked at __thread a couple of
years ago but found that support for the kernel segment register was not
available. If we had __thread then most of the operations could simply be
provided by the compiler.



