Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbbAFUEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:04:16 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:54214 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbAFUEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <CAHTgTXUGVkJX26bFSOC9EH2gUynSKhLNr7D8mN8cSy7Km_+f9Q@mail.gmail.com>
References: <CAHTgTXUGVkJX26bFSOC9EH2gUynSKhLNr7D8mN8cSy7Km_+f9Q@mail.gmail.com>
Date: Tue, 6 Jan 2015 12:04:13 -0800
Message-ID: <CAHA+R7OPJp9ayT6_zN6MxJd8arZyB4WGJ_3_pggwvTkwL9P2+w@mail.gmail.com>
Subject: Re: next-timestamp build failure with 3.19-rc2
From: Cong Wang <cwang@twopensource.com>
To: Vinson Lee <vlee@twopensource.com>
Cc: Jonathan Corbet <corbet@lwn.net>, "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 11:55 AM, Vinson Lee <vlee@twopensource.com> wrote:
> Hi.
>
> I'm hitting the following build error with 3.19-rc2 on CentOS 5 with
> glibc-headers-2.5-123.
>
>   HOSTCC  Documentation/networking/timestamping/txtimestamp
> Documentation/networking/timestamping/txtimestamp.c:64:8: error:
> redefinition of ‘struct in6_pktinfo’
>  struct in6_pktinfo {
>         ^
> In file included from /usr/include/arpa/inet.h:23:0,
>                  from Documentation/networking/timestamping/txtimestamp.c:33:
> /usr/include/netinet/in.h:456:8: note: originally defined here
>  struct in6_pktinfo
>         ^

We need the same workaround as we did for in6_addr etc..
I am working on a patch now.
