Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaCKPxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:53:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaCKPxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:53:10 -0400
Message-ID: <531F3159.6060607@redhat.com>
Date: Tue, 11 Mar 2014 16:52:57 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tobias Klauser <tklauser@distanz.ch>
CC: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add tools/net to NETWORKING [GENERAL]
References: <1394535984-17924-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1394535984-17924-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 12:06 PM, Tobias Klauser wrote:
> Make sure patches for these tools go to the netdev list as well.
>
> References: https://marc.info/?l=linux-kernel&m=139450284501328&w=2
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Daniel Borkmann <dborkman@redhat.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>   MAINTAINERS |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ab32ad5..fa7b379 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6042,6 +6042,7 @@ F:	include/linux/netdevice.h
>   F:	include/uapi/linux/in.h
>   F:	include/uapi/linux/net.h
>   F:	include/uapi/linux/netdevice.h
> +F:	tools/net/

We should perhaps also add an entry for networking
selftests later on, that is:

   tools/testing/selftests/net/

>   NETWORKING [IPv4/IPv6]
>   M:	"David S. Miller" <davem@davemloft.net>
>
