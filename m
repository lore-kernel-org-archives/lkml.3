Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3LKD1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:27:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3LKD1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:27:37 -0500
Message-ID: <52A7DB8E.9080101@redhat.com>
Date: Wed, 11 Dec 2013 11:27:10 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com, mst@redhat.com, vyasevich@gmail.com
Subject: Re: [PATCH net V2 1/2] tun: unbreak truncated packet signalling
References: <1386654586-18151-1-git-send-email-jasowang@redhat.com> <20131210.221144.1520834419856689475.davem@davemloft.net>
In-Reply-To: <20131210.221144.1520834419856689475.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 11:11 AM, David Miller wrote:
> You and Michael are still discussing these changes it seems.
>
> I accidently commited the first version of these patches, but then
> immediately reverted that after I saw the followups.
>
> Let me know when you have something both of you are happy with.
>
> Thanks.

Sure, I will post v3 which should address all comments from Michael.

Thanks
