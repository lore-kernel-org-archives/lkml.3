Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3AKIio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:38:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab3AKIin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:38:43 -0500
Message-ID: <50EFCF8A.3020907@redhat.com>
Date: Fri, 11 Jan 2013 16:38:34 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: stefanha@redhat.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.8-rc] tuntap: refuse to re-attach to different tun_struct
References: <1357804788-19976-1-git-send-email-stefanha@redhat.com> <20130110.143902.2166041015759450388.davem@davemloft.net> <50EF6AF0.1020005@redhat.com> <20130110.211237.653335807366477404.davem@davemloft.net>
In-Reply-To: <20130110.211237.653335807366477404.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:12 PM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Fri, 11 Jan 2013 09:29:20 +0800
>
>> On 01/11/2013 06:39 AM, David Miller wrote:
>>> From: Stefan Hajnoczi <stefanha@redhat.com>
>>> Date: Thu, 10 Jan 2013 08:59:48 +0100
>>>
>>>> Multiqueue tun devices support detaching a tun_file from its tun_struct
>>>> and re-attaching at a later point in time.  This allows users to disable
>>>> a specific queue temporarily.
>>>>
>>>> ioctl(TUNSETIFF) allows the user to specify the network interface to
>>>> attach by name.  This means the user can attempt to attach to interface
>>>> "B" after detaching from interface "A".
>>>>
>>>> The driver is not designed to support this so check we are re-attaching
>>>> to the right tun_struct.  Failure to do so may lead to oops.
>>>>
>>>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>>> Applied.
>> Hi David:
>>
>> Any chance that I can have a respin on this patch, there's still a bug
>> after this patch. Or I just can send a patch on top?
> If I've applied it, there is no reverting.

Get it, will send patch on top.

Thanks
