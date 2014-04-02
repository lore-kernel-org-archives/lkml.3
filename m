Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbaDBJkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:40:21 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1847 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaDBJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:40:18 -0400
Message-ID: <533BDAA7.5070704@xs4all.nl>
Date: Wed, 02 Apr 2014 11:38:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LDOC <linux-doc@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] v4l2-pci-skeleton: fix typo while retrieving the skel_buffer
References: <1395683489-25986-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1395683489-25986-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/14 18:51, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Documentation/video4linux/v4l2-pci-skeleton.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
> index 3a1c0d2..61a56f4 100644
> --- a/Documentation/video4linux/v4l2-pci-skeleton.c
> +++ b/Documentation/video4linux/v4l2-pci-skeleton.c
> @@ -87,7 +87,7 @@ struct skel_buffer {
>  
>  static inline struct skel_buffer *to_skel_buffer(struct vb2_buffer *vb2)
>  {
> -	return container_of(vb2, struct skel_buffer, vb);
> +	return container_of(vb2, struct skel_buffer, vb2);

Why is this a type? The vb2_buffer member in struct skel_buffer is called
'vb', so this should be correct.

Regards,

	Hans

>  }
>  
>  static const struct pci_device_id skeleton_pci_tbl[] = {
> 

