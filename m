Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaDXVtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:49:46 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:48368 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaDXVtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <1398288285-16268-1-git-send-email-kys@microsoft.com>
References: <1398288285-16268-1-git-send-email-kys@microsoft.com>
Date: Thu, 24 Apr 2014 17:49:41 -0400
Message-ID: <CAJUuVQ7V+Se0auKdaiqPZr8i2WcNqWhHUwz8r85DKKCjnjtrvQ@mail.gmail.com>
Subject: Re: [PATCH V1 net-next 1/1] hyperv: Enable sendbuf mechanism on the
 send path
From: Andev <debiandev@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 5:24 PM, K. Y. Srinivasan <kys@microsoft.com> wrote:

>  drivers/net/hyperv/hyperv_net.h |   14 +++
>  drivers/net/hyperv/netvsc.c     |  226 +++++++++++++++++++++++++++++++++++++--
>  drivers/net/hyperv/netvsc_drv.c |    3 +->  3 files changed, 234 insertions(+), 9 deletions(-)

I just looked over netvsc.c and it could definitely use a more
consistent coding style.

Your use of goto exit/cleanup in some functions and returning directly
on errors in others could use a cleanup. Please consider doing that
while you are touching those files.
