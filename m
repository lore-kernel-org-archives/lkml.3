Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3AKFMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:12:39 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37616 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab3AKFMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:12:38 -0500
Date: Thu, 10 Jan 2013 21:12:37 -0800 (PST)
Message-Id: <20130110.211237.653335807366477404.davem@davemloft.net>
To: jasowang@redhat.com
Cc: stefanha@redhat.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.8-rc] tuntap: refuse to re-attach to different
 tun_struct
From: David Miller <davem@davemloft.net>
In-Reply-To: <50EF6AF0.1020005@redhat.com>
References: <1357804788-19976-1-git-send-email-stefanha@redhat.com>
	<20130110.143902.2166041015759450388.davem@davemloft.net>
	<50EF6AF0.1020005@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 11 Jan 2013 09:29:20 +0800

> On 01/11/2013 06:39 AM, David Miller wrote:
>> From: Stefan Hajnoczi <stefanha@redhat.com>
>> Date: Thu, 10 Jan 2013 08:59:48 +0100
>>
>>> Multiqueue tun devices support detaching a tun_file from its tun_struct
>>> and re-attaching at a later point in time.  This allows users to disable
>>> a specific queue temporarily.
>>>
>>> ioctl(TUNSETIFF) allows the user to specify the network interface to
>>> attach by name.  This means the user can attempt to attach to interface
>>> "B" after detaching from interface "A".
>>>
>>> The driver is not designed to support this so check we are re-attaching
>>> to the right tun_struct.  Failure to do so may lead to oops.
>>>
>>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>> Applied.
> Hi David:
> 
> Any chance that I can have a respin on this patch, there's still a bug
> after this patch. Or I just can send a patch on top?

If I've applied it, there is no reverting.
