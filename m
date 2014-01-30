Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaA3TkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:40:11 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:54459 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3TkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:40:09 -0500
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6Q+wOLMVdsON0yyP2FHvdxSBF3TX3fXw8Y23t8O704Nw@mail.gmail.com>
References: <CA+5PVA555XRvPfnJpDU2t-iCA1Ay2F-pxWACO_Hj_XBzjScK1w@mail.gmail.com>
	<CAOMZO5Cg3c1YNoyLwQROF0n_kMzKuyg5zw4x706ner6aPLBS8g@mail.gmail.com>
	<CA+5PVA6Q+wOLMVdsON0yyP2FHvdxSBF3TX3fXw8Y23t8O704Nw@mail.gmail.com>
Date: Thu, 30 Jan 2014 17:40:08 -0200
Message-ID: <CAOMZO5BOXXOBdxeCggnwATuGzpLZJiGwdpCmBRe=8NXBSNWqWQ@mail.gmail.com>
Subject: Re: imx-hdmi fails to build with v3.13-10094-g9b0cd30
From: Fabio Estevam <festevam@gmail.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@gmail.com>, devel@driverdev.osuosl.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 5:33 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Thu, Jan 30, 2014 at 2:31 PM, Fabio Estevam <festevam@gmail.com> wrote:
>> On Thu, Jan 30, 2014 at 5:28 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>> Hi All,
>>>
>>> After the DRM merge the imx-hdmi driver fails to build with the error
>>> below.  I'm somewhat surprised this wasn't hit in linux-next.
>>>
>>
>> Sachin has already sent a patch to fix this issue:
>> http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2014-January/045167.html
>
> Wonderful.  Thanks for the quick response.
>
> Out of curiosity, was this hit in linux-next?  Or is the config option
> not enabled in any of the configs built there?

The imx-hdmi driver is not enabled in imx_v6_v7_defconfig yet.

Russell King has a large series of patches for imx-drm that among
other things, it will add the device tree pieces as well as select the
imx-hdmi in imx_v6_v7_defconfig.

Regards,

Fabio Estevam
