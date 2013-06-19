Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab3FSGeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:34:20 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:33130 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab3FSGeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:34:18 -0400
Message-ID: <1371623653.3252.268.camel@edumazet-glaptop>
Subject: Re: [net-next rfc 3/3] tuntap: increase the max queues to 16
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, hkchu@google.com, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Jun 2013 23:34:13 -0700
In-Reply-To: <1371620452-49349-4-git-send-email-jasowang@redhat.com>
References: <1371620452-49349-1-git-send-email-jasowang@redhat.com>
	 <1371620452-49349-4-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 13:40 +0800, Jason Wang wrote:
> Since we've reduce the size of tun_struct and use flex array to allocate netdev
> queues, it's safe for us to increase the limit of queues in tuntap.

Its already safe to increase max queues to 16, without your patches 1 &
2



