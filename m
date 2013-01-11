Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3AKB30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:29:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3AKB3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:29:25 -0500
Message-ID: <50EF6AF0.1020005@redhat.com>
Date: Fri, 11 Jan 2013 09:29:20 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: stefanha@redhat.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.8-rc] tuntap: refuse to re-attach to different tun_struct
References: <1357804788-19976-1-git-send-email-stefanha@redhat.com> <20130110.143902.2166041015759450388.davem@davemloft.net>
In-Reply-To: <20130110.143902.2166041015759450388.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 06:39 AM, David Miller wrote:
> From: Stefan Hajnoczi <stefanha@redhat.com>
> Date: Thu, 10 Jan 2013 08:59:48 +0100
>
>> Multiqueue tun devices support detaching a tun_file from its tun_struct
>> and re-attaching at a later point in time.  This allows users to disable
>> a specific queue temporarily.
>>
>> ioctl(TUNSETIFF) allows the user to specify the network interface to
>> attach by name.  This means the user can attempt to attach to interface
>> "B" after detaching from interface "A".
>>
>> The driver is not designed to support this so check we are re-attaching
>> to the right tun_struct.  Failure to do so may lead to oops.
>>
>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> Applied.
Hi David:

Any chance that I can have a respin on this patch, there's still a bug
after this patch. Or I just can send a patch on top?

Thanks
