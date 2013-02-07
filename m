Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3BGLsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:48:35 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:49717 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3BGLsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:48:30 -0500
X-AuditID: cbfec7f5-b7fd76d000007247-6b-5113948ce10a
Message-id: <5113948A.5070209@samsung.com>
Date: Thu, 07 Feb 2013 12:48:26 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] media: add support for decoder as one of media entity
 types
References: <1359373843-15956-1-git-send-email-prabhakar.lad@ti.com>
In-reply-to: <1359373843-15956-1-git-send-email-prabhakar.lad@ti.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xy7o9U4QDDQ4d5LZY2LaExeLyrjls
	Fj0btrI6MHt83iQXwBjFZZOSmpNZllqkb5fAlbH/63+Wgv3sFXsXXGZqYFzC1sXIwSEhYCLx
	YkFGFyMnkCkmceHeeqAwF4eQwFJGiW0981ghnE+MEp1HprOCVPEKaEm8mzqdDcRmEVCVuLdo
	MwuIzSZgKNF7tI8RxBYVCJBYvOQcO0S9oMSPyffAakQE9CSWLDjGDDKUWWAek8T+6UfAGoQF
	QiVmNJ0BKxIScJE4M/8bWJxTwFXi0qGlzCA2s4C6xKR5i6BseYnNa94yT2AUmIVkxywkZbOQ
	lC1gZF7FKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERKWX3cwLj1mdYhRgINRiYf35lKhQCHW
	xLLiytxDjBIczEoivCdrhAOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MGYd3vhB1O7m11SJ611f
	BGTXHgqXLpkQctRw88GXs0XlLFepbu2cl+esHd4ya76ZwZmIxMu3Hma1W+a1uGw/8EZmzaTm
	X1MfBxvyiRZybGjZv+rdkpf5+ea3z985Zym7bHea2bpHsgZzBOs5d03+88PPe2+GB9/t7B0/
	p7hurNE/O+cXz6Rbcz2VWIozEg21mIuKEwG1yzFSKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 01/28/2013 12:50 PM, Prabhakar Lad wrote:
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 0ef8833..dac06d7 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -56,6 +56,8 @@ struct media_device_info {
>  #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV + 1)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV + 2)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV + 3)
> +/* DECODER: Converts analogue video to digital */

The patch looks good to me, I would just change this comment to
something like:

/* A converter of analogue video to its digital representation. */

But that's really a nitpicking.

> +#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
>  
>  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Thanks,
Sylwester
