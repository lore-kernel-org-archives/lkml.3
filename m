Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab3BMDVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:21:25 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:35192 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752309Ab3BMDVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:21:24 -0500
Date: Tue, 12 Feb 2013 19:21:23 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net
Message-ID: <391933308.1119093.1360725683160.JavaMail.root@vmware.com>
In-Reply-To: <1675407061.963254.1360682467627.JavaMail.root@vmware.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <5118FEA9.2080201@redhat.com> <1675407061.963254.1360682467627.JavaMail.root@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.62.221]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: fbcLzOd8oom6Dq4OLGpObN+q9DlUg2E779gp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> stream_has_data: Returns amount of data available (in bytes) in the
> socket's receive buffer, or -1 if empty.
> 
> stream_has_space: Returns amount of space available (in bytes) in the
> socket's send buffer, or -1 if full.

Actually, I think it's for empty/full, and -1 for an error (say, the
transport closed or whatever).

Thanks!
- Andy
