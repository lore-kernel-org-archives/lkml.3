Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3BRRJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:09:25 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:57755 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab3BRRJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:09:24 -0500
Date: Mon, 18 Feb 2013 09:09:23 -0800 (PST)
From: Andy King <acking@vmware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com, kraxel@redhat.com
Message-ID: <1877909883.2079524.1361207363932.JavaMail.root@vmware.com>
In-Reply-To: <CA+1xoqfWGUuFjruFk1UV1BAXwzZvX4_i0MShQEpsq69B6P9ieg@mail.gmail.com>
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com> <CA+1xoqfWGUuFjruFk1UV1BAXwzZvX4_i0MShQEpsq69B6P9ieg@mail.gmail.com>
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.163.67]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - GC24 (Mac)/8.0.2_GA_5569)
Thread-Topic: VSOCK: Introduce VM Sockets
Thread-Index: /0QMlHIuAQ0pOWuL/AqEvVQw3GgRSA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

> > + * Specifically, we initialize the vsock_bind_table array to a size of
> > + * VSOCK_HASH_SIZE + 1 so that vsock_bind_table[0] through
...
> Why isn't it using the kernel's linux/hashtable.h?

Gah, that's a leftover from when it was platform independent :/  I have a
patch lying around to address this, once we have some more fixes batched
up I'll send it out.  Sorry about that!

Thanks!
- Andy
