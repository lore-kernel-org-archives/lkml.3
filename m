Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaKNOGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:06:33 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49313 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754509AbaKNOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:06:31 -0500
Date: Fri, 14 Nov 2014 15:58:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] [media] Add RGB444_1X12 and RGB565_1X16 media bus formats
Message-ID: <20141114135831.GC8907@valkosipuli.retiisi.org.uk>
References: <1415961360-14898-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415961360-14898-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Fri, Nov 14, 2014 at 11:36:00AM +0100, Boris Brezillon wrote:
> Add RGB444_1X12 and RGB565_1X16 format definitions and update the
> documentation.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  Documentation/DocBook/media/v4l/subdev-formats.xml | 40 ++++++++++++++++++++++
>  include/uapi/linux/media-bus-format.h              |  4 ++-
>  2 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
> index 18730b9..8c396db 100644
> --- a/Documentation/DocBook/media/v4l/subdev-formats.xml
> +++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
> @@ -563,6 +563,46 @@
>  	      <entry>b<subscript>1</subscript></entry>
>  	      <entry>b<subscript>0</subscript></entry>
>  	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB444-1X12">
> +	      <entry>MEDIA_BUS_FMT_RGB444_1X12</entry>
> +	      <entry>0x100d</entry>
> +	      <entry></entry>
> +	      &dash-ent-20;
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="MEDIA-BUS-FMT-RGB565-1X16">
> +	      <entry>MEDIA_BUS_FMT_RGB565_1X16</entry>
> +	      <entry>0x100d</entry>
> +	      <entry></entry>
> +	      &dash-ent-16;
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
>  	  </tbody>
>  	</tgroup>
>        </table>
> diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
> index 23b4090..cc7b79e 100644
> --- a/include/uapi/linux/media-bus-format.h
> +++ b/include/uapi/linux/media-bus-format.h
> @@ -33,7 +33,7 @@
>  
>  #define MEDIA_BUS_FMT_FIXED			0x0001
>  
> -/* RGB - next is	0x100e */
> +/* RGB - next is	0x1010 */
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
>  #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
>  #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
> @@ -47,6 +47,8 @@
>  #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
>  #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
>  #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
> +#define MEDIA_BUS_FMT_RGB444_1X12		0x100e
> +#define MEDIA_BUS_FMT_RGB565_1X16		0x100f

I'd arrange these according to BPP and bits per sample, both in the header
and documentation.

>  /* YUV (including grey) - next is	0x2024 */
>  #define MEDIA_BUS_FMT_Y8_1X8			0x2001

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
