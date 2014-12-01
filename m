Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaLAFe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 00:34:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaLAFe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 00:34:57 -0500
Date: Mon, 01 Dec 2014 05:42:47 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net-next] vhost: remove unnecessary forward declarations
 in vhost.h
To: David Miller <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Message-Id: <1417412087.7521.1@smtp.corp.redhat.com>
In-Reply-To: <20141129.210422.2298555198780052887.davem@davemloft.net>
References: <1417070481-10331-1-git-send-email-jasowang@redhat.com>
	<20141129.210422.2298555198780052887.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, Nov 30, 2014 at 1:04 PM, David Miller <davem@davemloft.net> 
wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Thu, 27 Nov 2014 14:41:21 +0800
> 
>>  Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> I don't think generic vhost patches should go via my tree.
> 
> If you disagree, let me know why, thanks :)

Agree. Michael, could you pls pick this into vhost tree?

