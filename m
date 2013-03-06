Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3CFFQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753Ab3CFFQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:16:26 -0500
Message-ID: <5136D11B.9050905@redhat.com>
Date: Wed, 06 Mar 2013 13:16:11 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: maxk@qti.qualcomm.com, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mst@redhat.com,
        hkchu@google.com
Subject: Re: [PATCH] net: docs: document multiqueue tuntap API
References: <1362539123-24863-1-git-send-email-jasowang@redhat.com> <20130305.235401.548455441771005291.davem@davemloft.net>
In-Reply-To: <20130305.235401.548455441771005291.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 12:54 PM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed,  6 Mar 2013 11:05:23 +0800
>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Please fix these warnings emitted by GIT:
>
> Applying: net: docs: document multiqueue tuntap API
> /home/davem/src/GIT/net/.git/rebase-apply/patch:31: space before tab in indent.
>   	struct ifreq ifr;
> /home/davem/src/GIT/net/.git/rebase-apply/patch:32: space before tab in indent.
>   	int fd, err, i;
> /home/davem/src/GIT/net/.git/rebase-apply/patch:34: space before tab in indent.
>   	if (!dev)
> /home/davem/src/GIT/net/.git/rebase-apply/patch:35: space before tab in indent.
>   		return -1;
> /home/davem/src/GIT/net/.git/rebase-apply/patch:37: space before tab in indent.
>   	memset(&ifr, 0, sizeof(ifr));
> warning: squelched 29 whitespace errors
> warning: 34 lines add whitespace errors.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

My bad, will send v2.
