Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaHXOOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:14:43 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48894 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaHXOOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:14:41 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, k.opasiak@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v5 1/3] usb: gadget: f_fs: fix the redundant ep files problem
In-Reply-To: <1408622959-4096-2-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1408622959-4096-1-git-send-email-r.baldyga@samsung.com> <1408622959-4096-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140824:andrzej.p@samsung.com::3Lm6f/AYcxCq4xoV:00000000000000000000000000000000000000000MQW
X-Hashcash: 1:20:140824:m.szyprowski@samsung.com::/TJV5jc+umeTNutL:00000000000000000000000000000000000000JM2
X-Hashcash: 1:20:140824:gregkh@linuxfoundation.org::GFhgQXH2uc2X1Lno:000000000000000000000000000000000000Myv
X-Hashcash: 1:20:140824:k.opasiak@samsung.com::S5qpfcdu2yFzQ9m3:00000000000000000000000000000000000000000mYw
X-Hashcash: 1:20:140824:linux-kernel@vger.kernel.org::Pu/WBghCd/+3s1fB:00000000000000000000000000000000014Qk
X-Hashcash: 1:20:140824:r.baldyga@samsung.com::UWa/nOPPKt4VAwMk:000000000000000000000000000000000000000023mn
X-Hashcash: 1:20:140824:linux-usb@vger.kernel.org::cPRyhAKR2uvqOXDs:0000000000000000000000000000000000002jUk
X-Hashcash: 1:20:140824:balbi@ti.com::rUoAwoh77f/oz5cb:000007VV3
X-Hashcash: 1:20:140824:r.baldyga@samsung.com::mtG34FqC6r77imXW:0000000000000000000000000000000000000000CP4s
Date: Sun, 24 Aug 2014 16:14:36 +0200
Message-ID: <xa1tsikmug8j.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> Up to now, when endpoint addresses in descriptors were non-consecutive,
> there were created redundant files, which could cause problems in kernel,
> when user tryed to read/write to them. It was result of fact that maximum
            ^^^^^  -- tried

> endpoint address was taken as total number of endpoints in funciton.
>
> This patch adds endpoint descriptors counting and storing their addresses
> in eps_addrmap to verify their cohesion in each speed.
>
> Endpoint address map would be also useful for further features, just like
> vitual endpoint address mapping.
>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> @@ -1853,14 +1860,23 @@ static int __ffs_data_do_entity(enum ffs_entity_type type,
>  		 * Strings are indexed from 1 (0 is magic ;) reserved
>  		 * for languages list or some such)
>  		 */
> -		if (*valuep > ffs->strings_count)
> -			ffs->strings_count = *valuep;
> +		if (*valuep > helper->ffs->strings_count)
> +			helper->ffs->strings_count = *valuep;
>  		break;
>  
>  	case FFS_ENDPOINT:
> -		/* Endpoints are indexed from 1 as well. */
> -		if ((*valuep & USB_ENDPOINT_NUMBER_MASK) > ffs->eps_count)
> -			ffs->eps_count = (*valuep & USB_ENDPOINT_NUMBER_MASK);
> +		d = (void *)desc;
> +		helper->eps_count++;
> +		if (helper->eps_count >= 15)
> +			return -EINVAL;
> +		if (!helper->ffs->eps_count && !helper->ffs->interfaces_count)

I'd check helper->ffs->eps_count only.  helper->ffs->interfaces_count is
zero only because endpoints and interfaces are interpret at the same
time, but otherwise the interfaces_count is unrelated to what we're
doing here.

Also, perhaps adding a comment describing what !helper->ffs->eps_count
means makes sense here.

> +			helper->ffs->eps_addrmap[helper->eps_count] =
> +				d->bEndpointAddress;
> +		else if (helper->ffs->eps_count < helper->eps_count)
> +			return -EINVAL;

Doesn't this duplicate check in __ffs_data_got_descs?

> +		else if (helper->ffs->eps_addrmap[helper->eps_count] !=
> +				d->bEndpointAddress)
> +			return -EINVAL;
>  		break;
>  	}
>  
> @@ -2101,13 +2118,29 @@ static int __ffs_data_got_descs(struct ffs_data *ffs,
>  
>  	/* Read descriptors */
>  	raw_descs = data;
> +	helper.ffs = ffs;
>  	for (i = 0; i < 3; ++i) {
>  		if (!counts[i])
>  			continue;
> +		helper.interfaces_count = 0;
> +		helper.eps_count = 0;
>  		ret = ffs_do_descs(counts[i], data, len,
> -				   __ffs_data_do_entity, ffs);
> +				   __ffs_data_do_entity, &helper);
>  		if (ret < 0)
>  			goto error;
> +		if (!ffs->eps_count && !ffs->interfaces_count) {
> +			ffs->eps_count = helper.eps_count;
> +			ffs->interfaces_count = helper.interfaces_count;
> +		} else {
> +			if (ffs->eps_count != helper.eps_count) {
> +				ret = -EINVAL;
> +				goto error;
> +			}
> +			if (ffs->interfaces_count != helper.interfaces_count) {
> +				ret = -EINVAL;
> +				goto error;
> +			}
> +		}
>  		data += ret;
>  		len  -= ret;
>  	}
> @@ -2342,9 +2375,18 @@ static void ffs_event_add(struct ffs_data *ffs,
>  	spin_unlock_irqrestore(&ffs->ev.waitq.lock, flags);
>  }
>  
> -
>  /* Bind/unbind USB function hooks *******************************************/
>  
> +static int ffs_ep_addr2idx(struct ffs_data *ffs, u8 endpoint_address)
> +{
> +	int i;
> +
> +	for (i = 1; i < 15; ++i)

+	for (i = 1; i < ARRAY_SIZE(ffs->eps_addrmap); ++i)

> +		if (ffs->eps_addrmap[i] == endpoint_address)
> +			return i;
> +	return -ENOENT;
> +}
> +
>  static int __ffs_func_bind_do_descs(enum ffs_entity_type type, u8 *valuep,
>  				    struct usb_descriptor_header *desc,
>  				    void *priv)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
