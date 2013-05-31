Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3EaOsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:48:10 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52210 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3EaOsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:48:08 -0400
Message-ID: <51A8B829.7040708@cogentembedded.com>
Date: Fri, 31 May 2013 18:48:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Subject: Re: [net-next rfc V2 6/8] macvtap: allow TUNSETIFF to create multiqueue
 device
References: <1369994005-5943-1-git-send-email-jasowang@redhat.com> <1369994005-5943-7-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369994005-5943-7-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 31-05-2013 13:53, Jason Wang wrote:

> Though the queue were in fact created by open(), we still need to add this check
> to be compatible with tuntap which can let mgmt software use a single API to
> manage queues. This patch only validates the device name and moves the TUNSETIFF
> to a helper.

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/net/macvtap.c |   51 ++++++++++++++++++++++++++++++++++++++----------
>   1 files changed, 40 insertions(+), 11 deletions(-)

> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index e76484c..eac49cb 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -870,6 +870,7 @@ out:
>   	return ret;
>   }
>
> +

    Seems like random whitespace change.

>   static struct macvlan_dev *macvtap_get_vlan(struct macvtap_queue *q)
>   {
>   	struct macvlan_dev *vlan;
[...]

WBR, Sergei

