Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3BRQ4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:56:30 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:40692 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896Ab3BRQ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:56:29 -0500
Date: Mon, 18 Feb 2013 08:56:28 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Message-ID: <640503542.2078181.1361206588302.JavaMail.root@vmware.com>
In-Reply-To: <511B8AAF.2060202@redhat.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <511B8AAF.2060202@redhat.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.67]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: ZNlbJuNfcyE08dJhEdzMeTCiOIKv9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (protocol)
> > +		return -EPROTONOSUPPORT;
> > +
> 
> IMO protocol == PF_VSOCK should not get rejected here.

Good catch, I've sent out a patch for this.

Thanks!
- Andy
