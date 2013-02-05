Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3BEEmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 23:42:49 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:36785 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954Ab3BEEms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 23:42:48 -0500
Date: Mon, 4 Feb 2013 20:42:21 -0800 (PST)
From: Andy King <acking@vmware.com>
To: David Miller <davem@davemloft.net>
Cc: pv-drivers@vmware.com, gregkh@linuxfoundation.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dtor@vmware.com
Message-ID: <1979127675.2501555.1360039341169.JavaMail.root@vmware.com>
In-Reply-To: <20130108.174601.1788895671912734725.davem@davemloft.net>
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [108.68.97.87]
X-Mailer: Zimbra 7.2.0_GA_2681 (ZimbraWebClient - GC24 (Mac)/7.2.0_GA_2681)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> >> Instead, what I remember doing was deferring to the feedback these
> >> folks received, stating that ideas that the virtio people had
> >> mentioned should be considered instead.
> >> 
> >> http://marc.info/?l=linux-netdev&m=135301515818462&w=2
> > 
> > I believe Andy replied to Anthony's AF_VMCHANNEL post and the
> > differences between the proposed solutions.
> 
> I'd much rather see a hypervisor neutral solution than a hypervisor
> specific one which this certainly is.

We've addressed this with the latest patch series, which I sent earlier
today.  vSockets now has support for pluggable transports, of which VMCI
happens to be the first; all transport code is separated out into its
own module.  So the core is now hypervisor neutral.  Given that, would
you be willing to re-consider it, please?  If at all possible, we'd like
to make the current merge window.

Thanks so much!
- Andy
