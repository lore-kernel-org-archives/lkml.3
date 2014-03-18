Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaCRFtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:49:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34838 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaCRFtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:49:17 -0400
X-AuditID: cbfee690-b7f266d00000287c-d5-5327de5b3ca9
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
References: <5327D3C6.70400@gmail.com>
In-reply-to: <5327D3C6.70400@gmail.com>
Subject: Re: [PATCH] staging: slicoss: Fix prefer ether_addr_copy over memcpy
Date: Tue, 18 Mar 2014 14:49:15 +0900
Message-id: <000101cf426d$cba30240$62e906c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9CZ6EqKaapRqbcRdGSs+l64s0edQABK9Gg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+ZkW70PfVgg/3LpS1e/5vOYrHnzC92
	i+bF69ksLi+8xGox+/5jFoufW/4zWVzeNYfN4s2+nSwWixb/ZrfYua6T3YHL496+wyweO2fd
	ZfdYvOclk8f+uWvYPT4+vcXi8WXVNWaPvi2rGD2W3jvK6PF5k1wAZxSXTUpqTmZZapG+XQJX
	xs/LbYwFiyQrJr89xdjA+F+4i5GTQ0LARGL2/v9sELaYxIV764FsLg4hgWWMEk13fzHDFD1/
	eosRIrGIUWLujhdMEM5vRomv3buZQKrYBNQkvnw5zA5iiwjoSTQc7QXrYBZoZJa49nUv2A4h
	oKLbfVtZQWxOAXWJN+9aWUBsYQFfidULDjKC2CwCqhKL7k4Ai/MK2EocOveaGcIWlPgx+R5Y
	nFlAS2L9zuNMELa8xOY1b4FqOIBOVZd49FcX4gYjiXttl6DKRST2vXgHdo+EwEIOiR9/G5kh
	dglIfJt8iAWiV1Zi0wGojyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y
	0StOzC0uzUvXS87P3cQISQMTdjDeO2B9iDEZaP1EZinR5HxgGskriTc0NjOyMDUxNTYytzQj
	TVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbFdcbOM08sF9a8HbfGImJ/gsqK
	9gOVdqFtH3IPuEnLOe949GbRpX+Xj+w8rpa6e1qJXrxwRvdb1tQHmyM3vfM3fTT1lFyqoNju
	Pz/V1/LHvv7VeWtf58O8f7npl/9MDpZwDWuwM2yZpqS6sDilKeX0lI33z6xTjTshqilg26/X
	qVhU2yYW1qPEUpyRaKjFXFScCAAFzn2mGQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMKsWRmVeSWpSXmKPExsVy+t9jAd3oe+rBBtv+i1q8/jedxWLPmV/s
	Fs2L17NZXF54idVi9v3HLBY/t/xnsri8aw6bxZt9O1ksFi3+zW6xc10nuwOXx719h1k8ds66
	y+6xeM9LJo/9c9ewe3x8eovF48uqa8wefVtWMXosvXeU0ePzJrkAzqgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoFOVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBk/L7cxFiySrJj89hRjA+N/4S5GTg4JAROJ509vMULY
	YhIX7q1n62Lk4hASWMQoMXfHCyYI5zejxNfu3UwgVWwCahJfvhxmB7FFBPQkGo72MoIUMQs0
	Mktc+7qXDSQhBFR0u28rK4jNKaAu8eZdKwuILSzgK7F6wUGwdSwCqhKL7k4Ai/MK2EocOvea
	GcIWlPgx+R5YnFlAS2L9zuNMELa8xOY1b4FqOIBOVZd49FcX4gYjiXttl6DKRST2vXjHOIFR
	aBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQnmWdSOxhXNlgc
	YhTgYFTi4X3Bph4sxJpYVlyZe4hRgoNZSYR36WSgEG9KYmVValF+fFFpTmrxIcZkoEcnMkuJ
	JucDE2BeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTAuvvxW
	XfXfx5vu6X8kDi44JCG5Qpur8ooOp2LD5O1/l9w2eyZ599KJj7xTFv3pns/177Ogq3PeZgMB
	7/S3cqtMHIrerTiRc7g5QZXPcVHZpZwLyXMapKs/tFz3rV+1b8cXrvqZ3V//33ps6fGmm32e
	6dTAaV/X7UhQS7pyMeCSCf+JchWTx2l1SizFGYmGWsxFxYkAoWLd5HYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 18, 2014 2:04 PM, Joel Pelaez Jorge wrote:
> 
> This patch fixes the following checkpatch.pl issues caused by the new
> function: ether_addr_copy
> 
> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> ---
>   drivers/staging/slicoss/slicoss.c |   20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c
> b/drivers/staging/slicoss/slicoss.c
> index 12aafe3..0e0e374 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -581,15 +581,15 @@ static void slic_adapter_set_hwaddr(struct adapter
> *adapter)
>   	struct sliccard *card = adapter->card;
> 
>   	if ((adapter->card) && (card->config_set)) {
> -		memcpy(adapter->macaddr,
> -		       card->config.MacInfo[adapter->functionnumber].macaddrA,
> -		       sizeof(struct slic_config_mac));
> +		ether_addr_copy(adapter->macaddr,
> +				card->config.MacInfo[adapter->functionnumber]
> +				.macaddrA);

As declared in ./include/linux/etherdevice.h,
Copied size should be a six-byte.

static inline void ether_addr_copy(u8 *dst, const u8 *src)
{
#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
        *(u32 *)dst = *(const u32 *)src;
        *(u16 *)(dst + 4) = *(const u16 *)(src + 4);
#else
        u16 *a = (u16 *)dst;
        const u16 *b = (const u16 *)src;

        a[0] = b[0];
        a[1] = b[1];
        a[2] = b[2];
#endif
}

In this case, sizeof(struct slic_config_mac) will be 6 byte,
as below. So, it looks good.

./drivers/staging/slicoss/slichw.h
struct slic_config_mac {
        u8 macaddrA[6];
};

>   		if (is_zero_ether_addr(adapter->currmacaddr))
> -			memcpy(adapter->currmacaddr, adapter->macaddr,
> -			       ETH_ALEN);
> +			ether_addr_copy(adapter->currmacaddr,
> +					adapter->macaddr);
>   		if (adapter->netdev)
> -			memcpy(adapter->netdev->dev_addr, adapter->currmacaddr,
> -			       ETH_ALEN);
> +			ether_addr_copy(adapter->netdev->dev_addr,
> +					adapter->currmacaddr);
>   	}
>   }

ETH_ALEN is defined as 6. It looks good, too.

./include/uapi/linux/if_ether.h
#define ETH_ALEN     6

> 
> @@ -810,8 +810,8 @@ static int slic_mac_set_address(struct net_device
> *dev, void *ptr)
>   	if (!is_valid_ether_addr(addr->sa_data))
>   		return -EINVAL;
> 
> -	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
> -	memcpy(adapter->currmacaddr, addr->sa_data, dev->addr_len);
> +	ether_addr_copy(dev->dev_addr, addr->sa_data);
> +	ether_addr_copy(adapter->currmacaddr, addr->sa_data);

By the way, I am wondering if 'dev->addr_len' is 6 bytes.
Is there anyone who can confirm it?

If nobody can confirm 'dev->addr_len' is 6 bytes, it should
not be changed to 'ether_addr_copy()'.

Best regards,
Jingoo Han

> 
>   	slic_config_set(adapter, true);
>   	return 0;
> @@ -2313,7 +2313,7 @@ static int slic_mcast_add_list(struct adapter
> *adapter, char *address)
>   	if (mcaddr == NULL)
>   		return 1;
> 
> -	memcpy(mcaddr->address, address, ETH_ALEN);
> +	ether_addr_copy(mcaddr->address, address);
> 
>   	mcaddr->next = adapter->mcastaddrs;
>   	adapter->mcastaddrs = mcaddr;
> --
> 1.7.10.4

