Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaCRDiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 23:38:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16177 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaCRDiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 23:38:14 -0400
X-AuditID: cbfee68f-b7f156d00000276c-0e-5327bfa46801
From: Jingoo Han <jg1.han@samsung.com>
To: "'Joel Pelaez Jorge'" <joelpelaez@gmail.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'Rashika Kheria'" <rashika.kheria@gmail.com>,
        "'Peter P Waskiewicz Jr'" <peter.p.waskiewicz.jr@intel.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <5327BACF.5020102@gmail.com>
In-reply-to: <5327BACF.5020102@gmail.com>
Subject: Re: [PATCH] staging: slicoss: Fix prefer ether_addr_copy over memcpy
Date: Tue, 18 Mar 2014 12:38:12 +0900
Message-id: <002401cf425b$7d1db5f0$775921d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9CWJ50JSPc7Vo2RKCoMkIAQszu7gAAYwfg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zke6S/erBBn93G1i8/jedxWLPmV/s
	Fs2L17NZXF54idVi9v3HLBY/t/xnsri8aw6bxZt9O1ksFi3+zW6xc10nuwOXx719h1k8ds66
	y+6xeM9LJo/9c9ewe3x8eovF48uqa8wefVtWMXosvXeU0ePzJrkAzigum5TUnMyy1CJ9uwSu
	jJZTvAX9AhUH5r1hbGD8xt3FyMkhIWAisbtnEhOELSZx4d56NhBbSGAZo8Tiqx4wNasv3Qaq
	4QKKT2eUmLRwLSuE85tRomPKZrAONgE1iS9fDrOD2CICehINR3sZQYqYBRqZJa593Qs1VkPi
	2NufjCA2p4CmxMQNN8BWCwv4SqxecBAsziKgKjH1+DPmLkYODl4BW4nNV6xBwrwCghI/Jt9j
	AbGZBbQk1u88zgRhy0tsXvMWrFxCQF3i0V9diBOMJHr3bmOGKBGR2PfiHdg5EgJLOSTmP3/K
	ArFKQOLb5EMsEL2yEpsOMEM8LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFS
	epGxXnFibnFpXrpecn7uJkZIAujfwXj3gPUhxmSg9ROZpUST84EJJK8k3tDYzMjC1MTU2Mjc
	0ow0YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MHalNNqd3HP/xEYW2c7UfCFz
	PZm1pvPe3iyv/8l461PIORu3zXqPm7k0L75+XfYjJuvz3mf+GkaXtt/YWXxt/orpggfrgqf5
	6reJm393OsazzbAiwiKhKf2I2KE+ds8wqQDZTdtzH6Y32TXaTdK/fM00yOcQ28mq+0ePWbz/
	OzeGd89S/UuvO5VYijMSDbWYi4oTAbGno1YWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jQd0l+9WDDc6f07Z4/W86i8WeM7/Y
	LZoXr2ezuLzwEqvF7PuPWSx+bvnPZHF51xw2izf7drJYLFr8m91i57pOdgcuj3v7DrN47Jx1
	l91j8Z6XTB77565h9/j49BaLx5dV15g9+rasYvRYeu8oo8fnTXIBnFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QKcqKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDNaTvEW9AtUHJj3hrGB8Rt3FyMnh4SAicTqS7eZIGwx
	iQv31rN1MXJxCAlMZ5SYtHAtK4Tzm1GiY8pmNpAqNgE1iS9fDrOD2CICehINR3sZQYqYBRqZ
	Ja593QtWJCSgIXHs7U9GEJtTQFNi4oYbYCuEBXwlVi84CBZnEVCVmHr8GXMXIwcHr4CtxOYr
	1iBhXgFBiR+T77GA2MwCWhLrdx5ngrDlJTaveQtWLiGgLvHory7ECUYSvXu3MUOUiEjse/GO
	cQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOMM+kdjCu
	bLA4xCjAwajEw/uCTT1YiDWxrLgy9xCjBAezkgjv0slAId6UxMqq1KL8+KLSnNTiQ4zJQH9O
	ZJYSTc4HJr+8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCM
	vvqoe+2F8ir5VMn6oiimq9Mrl1XPmtXI6Mi18Pu7vqmWefObHM9ym9eaTgnWmvZ0acLH3zf2
	KHhlvr/+fu+t8g+/WH5ls95qnphonhxi8Erh9Me9jTUGUo55hZcX14eklvQHXHjHZXJ7+712
	zVm6f00OG3JcsJMW99qWcWLPn8lz4ya+eaqqxFKckWioxVxUnAgALLTM73QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 18, 2014 12:18 PM, Joel Pelaez Jorge wrote:
> 
> This patch fixes the following checkpatch.pl issues caused by the new
> function: ether_addr_copy
> 
> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> ---
> diff --git a/drivers/staging/slicoss/slicoss.c
> b/drivers/staging/slicoss/slicoss.c
> index 12aafe3..4ff39aa 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -2313,7 +2313,7 @@ static int slic_mcast_add_list(struct adapter
> *adapter, char *address)
>       if (mcaddr == NULL)
>           return 1;
> 
> -    memcpy(mcaddr->address, address, ETH_ALEN);
> +    ether_addr_copy(mcaddr->address, address);

In addition to this, there are the same cases like this,
in this file as below. Please search other same cases.
For instance, 'grep' will be a good way to find it.

static void slic_adapter_set_hwaddr(struct adapter *adapter)
{
        struct sliccard *card = adapter->card;

        if ((adapter->card) && (card->config_set)) {
                memcpy(adapter->macaddr,
                       card->config.MacInfo[adapter->functionnumber].macaddrA,
                       sizeof(struct slic_config_mac));
                if (is_zero_ether_addr(adapter->currmacaddr))
                        memcpy(adapter->currmacaddr, adapter->macaddr,
                               ETH_ALEN);
                if (adapter->netdev)
                        memcpy(adapter->netdev->dev_addr, adapter->currmacaddr,
                               ETH_ALEN);
        }
}

Joe Perches,
These are not spotted by checkpatch.pl.
However, after modifying it as below, checkpatch warnings are
printed. Would you confirm it?

	if (is_zero_ether_addr(adapter->currmacaddr))
		memcpy(adapter->currmacaddr, adapter->macaddr, ETH_ALEN);
	if (adapter->netdev)
		memcpy(adapter->netdev->dev_addr, adapter->currmacaddr, ETH_ALEN);
	}


Best regards,
Jingoo Han


> 
>       mcaddr->next = adapter->mcastaddrs;
>       adapter->mcastaddrs = mcaddr;

