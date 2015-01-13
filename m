Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbbAMMsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:48:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbAMMs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:48:29 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-85-54b5141a35c1
Message-id: <54B51419.4020604@samsung.com>
Date: Tue, 13 Jan 2015 13:48:25 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, Felipe Balbi <balbi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] usb: gadget: uvc: to_uvcg_control_header() can be
 static
References: <201501131627.qyQasDGL%fengguang.wu@intel.com>
 <20150113085538.GA9785@lkp-sb04>
In-reply-to: <20150113085538.GA9785@lkp-sb04>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7pSIltDDHrXq1scvF9v8f75emaL
	5sXr2SyOXZ/IbNE5cQm7xeVdc9gsFi1rZXZg97i/l91jdsdMVo/Fe14yeeyfu4bd4/iN7Uwe
	nzfJBbBFcdmkpOZklqUW6dslcGW8Ov6cpWCtQ8WhT0dZGxj7zLoYOTkkBEwkZi7/wgxhi0lc
	uLeerYuRi0NIYCmjxPsn71khnM+MEldazzCBVPEKaEnMudTOCmKzCKhKLFjayw5iswkYS+w9
	2MEIYosKhElMvPmYFaJeUOLH5HssILaIgJ7EioVtjCBDmQVuMEo0n14D1iwsECJxa9EksAVC
	ArESG+fvBWvgFNCVeH/9NxuIzSxgK7Hg/ToWCFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGK
	ppYmFxQnpeca6hUn5haX5qXrJefnbmKEhPuXHYyLj1kdYhTgYFTi4d2RvSVEiDWxrLgy9xCj
	BAezkgjvf4GtIUK8KYmVValF+fFFpTmpxYcYmTg4pRoYZ8yTj5adIZgc+qdMZe93E9XrenIi
	JgKrBB5Pnz5nZki2ld0HfrMnrBM42PtmXVrPJlY359nuhf6/smKrN9vuf/V8BmcH87PFK9q9
	WL5eMmncXu5xjn9pOF/P/RVvLi0qyOvycEx7f7G4auGkSsnJp/6siDrZvlbG+gbbPukfekph
	K56sn6SxR4mlOCPRUIu5qDgRAIhGSpRVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 13.01.2015 o 09:55, kbuild test robot pisze:
> drivers/usb/gadget/function/uvc_configfs.c:46:28: sparse: symbol 'to_uvcg_control_header' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:138:25: sparse: symbol 'uvcg_control_header_type' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:164:6: sparse: symbol 'uvcg_control_header_drop' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:721:20: sparse: symbol 'to_uvcg_format' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:798:30: sparse: symbol 'to_uvcg_streaming_header' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:950:25: sparse: symbol 'uvcg_streaming_header_type' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:976:6: sparse: symbol 'uvcg_streaming_header_drop' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1020:19: sparse: symbol 'to_uvcg_frame' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1265:25: sparse: symbol 'uvcg_frame_type' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1315:6: sparse: symbol 'uvcg_frame_drop' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1338:26: sparse: symbol 'to_uvcg_uncompressed' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1548:25: sparse: symbol 'uvcg_uncompressed_type' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1586:6: sparse: symbol 'uvcg_uncompressed_drop' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1610:19: sparse: symbol 'to_uvcg_mjpeg' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1761:25: sparse: symbol 'uvcg_mjpeg_type' was not declared. Should it be static?
> drivers/usb/gadget/function/uvc_configfs.c:1793:6: sparse: symbol 'uvcg_mjpeg_drop' was not declared. Should it be static?
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Reviewed-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>


> ---
>   uvc_configfs.c |   32 ++++++++++++++++----------------
>   1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
> index 33d92ab..f69f47a 100644
> --- a/drivers/usb/gadget/function/uvc_configfs.c
> +++ b/drivers/usb/gadget/function/uvc_configfs.c
> @@ -43,7 +43,7 @@ struct uvcg_control_header {
>   	unsigned			linked;
>   };
>
> -struct uvcg_control_header *to_uvcg_control_header(struct config_item *item)
> +static struct uvcg_control_header *to_uvcg_control_header(struct config_item *item)
>   {
>   	return container_of(item, struct uvcg_control_header, item);
>   }
> @@ -135,7 +135,7 @@ static struct configfs_attribute *uvcg_control_header_attrs[] = {
>   	NULL,
>   };
>
> -struct config_item_type uvcg_control_header_type = {
> +static struct config_item_type uvcg_control_header_type = {
>   	.ct_item_ops	= &uvcg_control_header_item_ops,
>   	.ct_attrs	= uvcg_control_header_attrs,
>   	.ct_owner	= THIS_MODULE,
> @@ -161,7 +161,7 @@ static struct config_item *uvcg_control_header_make(struct config_group *group,
>   	return &h->item;
>   }
>
> -void uvcg_control_header_drop(struct config_group *group,
> +static void uvcg_control_header_drop(struct config_group *group,
>   			      struct config_item *item)
>   {
>   	struct uvcg_control_header *h = to_uvcg_control_header(item);
> @@ -718,7 +718,7 @@ struct uvcg_format {
>   	__u8			bmaControls[UVCG_STREAMING_CONTROL_SIZE];
>   };
>
> -struct uvcg_format *to_uvcg_format(struct config_item *item)
> +static struct uvcg_format *to_uvcg_format(struct config_item *item)
>   {
>   	return container_of(to_config_group(item), struct uvcg_format, group);
>   }
> @@ -795,7 +795,7 @@ struct uvcg_streaming_header {
>   	unsigned					num_fmt;
>   };
>
> -struct uvcg_streaming_header *to_uvcg_streaming_header(struct config_item *item)
> +static struct uvcg_streaming_header *to_uvcg_streaming_header(struct config_item *item)
>   {
>   	return container_of(item, struct uvcg_streaming_header, item);
>   }
> @@ -947,7 +947,7 @@ static struct configfs_attribute *uvcg_streaming_header_attrs[] = {
>   	NULL,
>   };
>
> -struct config_item_type uvcg_streaming_header_type = {
> +static struct config_item_type uvcg_streaming_header_type = {
>   	.ct_item_ops	= &uvcg_streaming_header_item_ops,
>   	.ct_attrs	= uvcg_streaming_header_attrs,
>   	.ct_owner	= THIS_MODULE,
> @@ -973,7 +973,7 @@ static struct config_item
>   	return &h->item;
>   }
>
> -void uvcg_streaming_header_drop(struct config_group *group,
> +static void uvcg_streaming_header_drop(struct config_group *group,
>   			      struct config_item *item)
>   {
>   	struct uvcg_streaming_header *h = to_uvcg_streaming_header(item);
> @@ -1017,7 +1017,7 @@ struct uvcg_frame {
>   	struct config_item	item;
>   };
>
> -struct uvcg_frame *to_uvcg_frame(struct config_item *item)
> +static struct uvcg_frame *to_uvcg_frame(struct config_item *item)
>   {
>   	return container_of(item, struct uvcg_frame, item);
>   }
> @@ -1262,7 +1262,7 @@ static struct configfs_attribute *uvcg_frame_attrs[] = {
>   	NULL,
>   };
>
> -struct config_item_type uvcg_frame_type = {
> +static struct config_item_type uvcg_frame_type = {
>   	.ct_item_ops	= &uvcg_frame_item_ops,
>   	.ct_attrs	= uvcg_frame_attrs,
>   	.ct_owner	= THIS_MODULE,
> @@ -1312,7 +1312,7 @@ static struct config_item *uvcg_frame_make(struct config_group *group,
>   	return &h->item;
>   }
>
> -void uvcg_frame_drop(struct config_group *group, struct config_item *item)
> +static void uvcg_frame_drop(struct config_group *group, struct config_item *item)
>   {
>   	struct uvcg_frame *h = to_uvcg_frame(item);
>   	struct uvcg_format *fmt;
> @@ -1335,7 +1335,7 @@ struct uvcg_uncompressed {
>   	struct uvc_format_uncompressed	desc;
>   };
>
> -struct uvcg_uncompressed *to_uvcg_uncompressed(struct config_item *item)
> +static struct uvcg_uncompressed *to_uvcg_uncompressed(struct config_item *item)
>   {
>   	return container_of(
>   		container_of(to_config_group(item), struct uvcg_format, group),
> @@ -1545,7 +1545,7 @@ static struct configfs_attribute *uvcg_uncompressed_attrs[] = {
>   	NULL,
>   };
>
> -struct config_item_type uvcg_uncompressed_type = {
> +static struct config_item_type uvcg_uncompressed_type = {
>   	.ct_item_ops	= &uvcg_uncompressed_item_ops,
>   	.ct_group_ops	= &uvcg_uncompressed_group_ops,
>   	.ct_attrs	= uvcg_uncompressed_attrs,
> @@ -1583,7 +1583,7 @@ static struct config_group *uvcg_uncompressed_make(struct config_group *group,
>   	return &h->fmt.group;
>   }
>
> -void uvcg_uncompressed_drop(struct config_group *group,
> +static void uvcg_uncompressed_drop(struct config_group *group,
>   			    struct config_item *item)
>   {
>   	struct uvcg_uncompressed *h = to_uvcg_uncompressed(item);
> @@ -1607,7 +1607,7 @@ struct uvcg_mjpeg {
>   	struct uvc_format_mjpeg		desc;
>   };
>
> -struct uvcg_mjpeg *to_uvcg_mjpeg(struct config_item *item)
> +static struct uvcg_mjpeg *to_uvcg_mjpeg(struct config_item *item)
>   {
>   	return container_of(
>   		container_of(to_config_group(item), struct uvcg_format, group),
> @@ -1758,7 +1758,7 @@ static struct configfs_attribute *uvcg_mjpeg_attrs[] = {
>   	NULL,
>   };
>
> -struct config_item_type uvcg_mjpeg_type = {
> +static struct config_item_type uvcg_mjpeg_type = {
>   	.ct_item_ops	= &uvcg_mjpeg_item_ops,
>   	.ct_group_ops	= &uvcg_mjpeg_group_ops,
>   	.ct_attrs	= uvcg_mjpeg_attrs,
> @@ -1790,7 +1790,7 @@ static struct config_group *uvcg_mjpeg_make(struct config_group *group,
>   	return &h->fmt.group;
>   }
>
> -void uvcg_mjpeg_drop(struct config_group *group,
> +static void uvcg_mjpeg_drop(struct config_group *group,
>   			    struct config_item *item)
>   {
>   	struct uvcg_mjpeg *h = to_uvcg_mjpeg(item);
>

