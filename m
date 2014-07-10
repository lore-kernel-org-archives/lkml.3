Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaGJJBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:01:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:21121 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaGJJBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:01:30 -0400
X-IronPort-AV: E=Sophos;i="5.01,636,1400025600"; 
   d="scan'208";a="151573178"
Message-ID: <1404982886.30660.4.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH v7 15/33] net: xen-netback - set name assign type
From: Ian Campbell <ian.campbell@citrix.com>
To: Tom Gundersen <teg@jklm.no>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Wei Liu <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>
Date: Thu, 10 Jul 2014 10:01:26 +0100
In-Reply-To: <1404980258-30853-16-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	 <1404980258-30853-16-git-send-email-teg@jklm.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 10:17 +0200, Tom Gundersen wrote:
> The name contains then xen handle, which is not guaranteed to be
> stable between restarts, so label this NET_NAME_ENUM.

FWIW the N'th interface for domain with domid D will always be named
vifD.N.

If you reboot domain D then it's domid will change to E and the new
device will be vifE.N.

I don't know if that counts as predictable as far as the interface you
are introducing is concerned.

Ian.

