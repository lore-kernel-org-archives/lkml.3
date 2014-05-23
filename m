Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaEWWib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:38:31 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:40764 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEWWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:38:30 -0400
X-AuditID: cbfec373-b7fd56d0000060dc-5a-537fcde4787c
Date: Fri, 23 May 2014 19:38:22 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 41/49] media: davinci: vpif_capture: drop unneeded
 module params
Message-id: <20140523193822.3c097380.m.chehab@samsung.com>
In-reply-to: <1400247235-31434-44-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
 <1400247235-31434-44-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/hQN0nZ+uDDXp26Fmcu9XAarHk5y4m
	i8u75rBZ9GzYymrx8v4KZgdWjym/N7J67Jx1l91jzrQmFo/Pm+QCWKK4bFJSczLLUov07RK4
	Mv49uMtasFu14szXPuYGxk75LkZODgkBE4m+Fe/YIWwxiQv31rN1MXJxCAksYZT4u+sJlNPA
	JPH653JmkCoWAVWJV983g9lsAkYSrxpbWEFsEQFDic6HK1hBGpgF1jJKTFyxAmyssECkxKJd
	nSwgNq+AlcSmKU/BmjkFfCS+z9rFArGhh1Hi4LuPjBB3OEm8ej2ZCaJBUOLH5HtgzcwCWhKb
	tzWxQtjyEpvXvGWewCgwC0nZLCRls5CULWBkXsUoWlqcXFCclJ5rpFecmFtcmpeul5yfu4kR
	EszFOxhfbLA6xCjAwajEw8s4rT5YiDWxrLgy9xCjBAezkgjvn0NAId6UxMqq1KL8+KLSnNTi
	Q4xMHJxSDYwMagKnnzc/N7vsurV2fYT/uq5rq1ZHcN1mOZbzav7Duj8xlie6Uj4xin87an/p
	yIETZl3xoskVeae/fWh9GTpr6sZVx+50LLwQ+OvvZtYkTglvsb2XKma9+sJj9KXCOs9Rt801
	Qfrl9mCG6TH6Xx9vts6bM2GtfL3Z1N6S57wmsSkZU4Ld76kosRRnJBpqMRcVJwIA0e3tl0QC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 16 May 2014 19:03:47 +0530
"Lad, Prabhakar" <prabhakar.csengg@gmail.com> escreveu:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

-ENOPATCHDESCRIPTION!!!!

Why to remove those parameters? Please _ALWAYS_ describe your patches.

My crystal ball is malfunctioning today, so I was unable to scry the
reasons for this patch.

Thanks,
Mauro

> ---
>  drivers/media/platform/davinci/vpif_capture.c |   54 +------------------------
>  drivers/media/platform/davinci/vpif_capture.h |   11 -----
>  2 files changed, 1 insertion(+), 64 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index d452eaf..e967cf7 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -38,32 +38,10 @@ MODULE_VERSION(VPIF_CAPTURE_VERSION);
>  		v4l2_dbg(level, debug, &vpif_obj.v4l2_dev, fmt, ## arg)
>  
>  static int debug = 1;
> -static u32 ch0_numbuffers = 3;
> -static u32 ch1_numbuffers = 3;
> -static u32 ch0_bufsize = 1920 * 1080 * 2;
> -static u32 ch1_bufsize = 720 * 576 * 2;
>  
>  module_param(debug, int, 0644);
> -module_param(ch0_numbuffers, uint, S_IRUGO);
> -module_param(ch1_numbuffers, uint, S_IRUGO);
> -module_param(ch0_bufsize, uint, S_IRUGO);
> -module_param(ch1_bufsize, uint, S_IRUGO);
>  
>  MODULE_PARM_DESC(debug, "Debug level 0-1");
> -MODULE_PARM_DESC(ch2_numbuffers, "Channel0 buffer count (default:3)");
> -MODULE_PARM_DESC(ch3_numbuffers, "Channel1 buffer count (default:3)");
> -MODULE_PARM_DESC(ch2_bufsize, "Channel0 buffer size (default:1920 x 1080 x 2)");
> -MODULE_PARM_DESC(ch3_bufsize, "Channel1 buffer size (default:720 x 576 x 2)");
> -
> -static struct vpif_config_params config_params = {
> -	.min_numbuffers = 3,
> -	.numbuffers[0] = 3,
> -	.numbuffers[1] = 3,
> -	.min_bufsize[0] = 720 * 480 * 2,
> -	.min_bufsize[1] = 720 * 480 * 2,
> -	.channel_bufsize[0] = 1920 * 1080 * 2,
> -	.channel_bufsize[1] = 720 * 576 * 2,
> -};
>  
>  #define VPIF_DRIVER_NAME	"vpif_capture"
>  
> @@ -609,9 +587,6 @@ static void vpif_config_format(struct channel_obj *ch)
>  	vpif_dbg(2, debug, "vpif_config_format\n");
>  
>  	common->fmt.fmt.pix.field = V4L2_FIELD_ANY;
> -	common->fmt.fmt.pix.sizeimage
> -	    = config_params.channel_bufsize[ch->channel_id];
> -
>  	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER)
>  		common->fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SBGGR8;
>  	else
> @@ -1358,36 +1333,9 @@ static struct v4l2_file_operations vpif_fops = {
>   */
>  static int initialize_vpif(void)
>  {
> -	int err = 0, i, j;
> +	int err, i, j;
>  	int free_channel_objects_index;
>  
> -	/* Default number of buffers should be 3 */
> -	if ((ch0_numbuffers > 0) &&
> -	    (ch0_numbuffers < config_params.min_numbuffers))
> -		ch0_numbuffers = config_params.min_numbuffers;
> -	if ((ch1_numbuffers > 0) &&
> -	    (ch1_numbuffers < config_params.min_numbuffers))
> -		ch1_numbuffers = config_params.min_numbuffers;
> -
> -	/* Set buffer size to min buffers size if it is invalid */
> -	if (ch0_bufsize < config_params.min_bufsize[VPIF_CHANNEL0_VIDEO])
> -		ch0_bufsize =
> -		    config_params.min_bufsize[VPIF_CHANNEL0_VIDEO];
> -	if (ch1_bufsize < config_params.min_bufsize[VPIF_CHANNEL1_VIDEO])
> -		ch1_bufsize =
> -		    config_params.min_bufsize[VPIF_CHANNEL1_VIDEO];
> -
> -	config_params.numbuffers[VPIF_CHANNEL0_VIDEO] = ch0_numbuffers;
> -	config_params.numbuffers[VPIF_CHANNEL1_VIDEO] = ch1_numbuffers;
> -	if (ch0_numbuffers) {
> -		config_params.channel_bufsize[VPIF_CHANNEL0_VIDEO]
> -		    = ch0_bufsize;
> -	}
> -	if (ch1_numbuffers) {
> -		config_params.channel_bufsize[VPIF_CHANNEL1_VIDEO]
> -		    = ch1_bufsize;
> -	}
> -
>  	/* Allocate memory for six channel objects */
>  	for (i = 0; i < VPIF_CAPTURE_MAX_DEVICES; i++) {
>  		vpif_obj.dev[i] =
> diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
> index 4960504..537076a 100644
> --- a/drivers/media/platform/davinci/vpif_capture.h
> +++ b/drivers/media/platform/davinci/vpif_capture.h
> @@ -125,16 +125,5 @@ struct vpif_device {
>  	struct vpif_capture_config *config;
>  };
>  
> -struct vpif_config_params {
> -	u8 min_numbuffers;
> -	u8 numbuffers[VPIF_CAPTURE_NUM_CHANNELS];
> -	s8 device_type;
> -	u32 min_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
> -	u32 channel_bufsize[VPIF_CAPTURE_NUM_CHANNELS];
> -	u8 default_device[VPIF_CAPTURE_NUM_CHANNELS];
> -	u32 video_limit[VPIF_CAPTURE_NUM_CHANNELS];
> -	u8 max_device_type;
> -};
> -
>  #endif				/* End of __KERNEL__ */
>  #endif				/* VPIF_CAPTURE_H */
