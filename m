Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3AJWii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 17:38:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34565 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3AJWig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 17:38:36 -0500
Date: Thu, 10 Jan 2013 14:38:35 -0800 (PST)
Message-Id: <20130110.143835.2008690798301758570.davem@davemloft.net>
To: stefanha@redhat.com
Cc: mst@redhat.com, jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tun: avoid owner checks on IFF_ATTACH_QUEUE
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130110115503.GD30885@stefanha-thinkpad.redhat.com>
References: <20130110113108.GF13451@redhat.com>
	<20130110115503.GD30885@stefanha-thinkpad.redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 10 Jan 2013 12:55:03 +0100

> On Thu, Jan 10, 2013 at 01:31:08PM +0200, Michael S. Tsirkin wrote:
>> At the moment, we check owner when we enable queue in tun.
>> This seems redundant and will break some valid uses
>> where fd is passed around: I think TUNSETOWNER is there
>> to prevent others from attaching to a persistent device not
>> owned by them. Here the fd is already attached,
>> enabling/disabling queue is more like read/write.
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> 
>> ---
>> 
>> Note: this is unrelated to Stefan's bugfix.
> 
> This should go into 3.8-rc.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Applied.
