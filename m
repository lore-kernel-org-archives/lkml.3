Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008Ab3BMMok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:44:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933935Ab3BMMoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:44:39 -0500
Message-ID: <511B8AAF.2060202@redhat.com>
Date: Wed, 13 Feb 2013 13:44:31 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Andy King <acking@vmware.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, pv-drivers@vmware.com
Subject: Re: [PATCH 1/1] VSOCK: Introduce VM Sockets
References: <1360196636-9357-1-git-send-email-acking@vmware.com> <1360196636-9357-2-git-send-email-acking@vmware.com>
In-Reply-To: <1360196636-9357-2-git-send-email-acking@vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/13 01:23, Andy King wrote:
> +static int vsock_create(struct net *net, struct socket *sock,
> +			int protocol, int kern)
> +{
> +	if (!sock)
> +		return -EINVAL;
> +
> +	if (protocol)
> +		return -EPROTONOSUPPORT;
> +

IMO protocol == PF_VSOCK should not get rejected here.

cheers,
  Gerd
