Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759617Ab3BMDXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:23:05 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:35326 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab3BMDXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:23:02 -0500
Date: Tue, 12 Feb 2013 19:23:02 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Message-ID: <89189590.1119233.1360725782323.JavaMail.root@vmware.com>
In-Reply-To: <511A2043.6040805@redhat.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <511A2043.6040805@redhat.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.62.221]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: Xe77zVVaIBKPN5Tl9QoZ7E/PxFH0RQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gerd,

> > +/* Option name for socket's service label.  Use as the option name in
> > + * setsockopt(3) or getsockopt(3) to set or get the service label for a
> > socket.
> > + * The service label is a C-style NUL-terminated string.  Only available
> > for
> > + * hypervisor endpoints.
> > + */
> > +
> > +#define SO_VM_SOCKETS_SERVICE_LABEL 4
> > +
> 
> What is this and how does it work?

Oops, that's specific to ESX.  Thankfully it's only in the header and not
in anything under net/vmw_vsock, so removing it is easy.  I'll send out a
patch in the morning.

Thanks!
- Andy
