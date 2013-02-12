Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab3BLK6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:58:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab3BLK6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:58:19 -0500
Message-ID: <511A2043.6040805@redhat.com>
Date: Tue, 12 Feb 2013 11:58:11 +0100
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

  Hi,

> +/* Option name for socket's service label.  Use as the option name in
> + * setsockopt(3) or getsockopt(3) to set or get the service label for a socket.
> + * The service label is a C-style NUL-terminated string.  Only available for
> + * hypervisor endpoints.
> + */
> +
> +#define SO_VM_SOCKETS_SERVICE_LABEL 4
> +

What is this and how does it work?

cheers,
  Gerd
