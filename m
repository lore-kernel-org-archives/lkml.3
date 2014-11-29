Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaK2Npu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 08:45:50 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46482 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaK2Npt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 08:45:49 -0500
MIME-Version: 1.0
In-Reply-To: <1417229371-9243-1-git-send-email-geoffda@comcast.net>
References: <1417229371-9243-1-git-send-email-geoffda@comcast.net>
Date: Sat, 29 Nov 2014 14:45:48 +0100
Message-ID: <CAAfyv37zpU27NEF5rFoVWseAkEmd60MZ-tMRJt0zObdynPi+4g@mail.gmail.com>
Subject: Re: [PATCH] Staging: ft1000 : ft1000-pcmcia: replace __attribute
 ((__packed__) with __packed macro per coding style guidelines in ft1000_dnld.c
From: Belisko Marek <marek.belisko@gmail.com>
To: Geoff Darst <geoffda@comcast.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please use shorter summary phrase (which appear an subject) + split
commit message to more line (not one long line).

marek

On Sat, Nov 29, 2014 at 3:49 AM, Geoff Darst <geoffda@comcast.net> wrote:
> Replace two instances of __attribute ((__packed__) with __packed macro to address the warning found by the checkpatch.pl tool.
>
> Signed-off-by: Geoff Darst <geoffda@comcast.net>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
> index c1856f7..df1cf0c 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
> @@ -99,7 +99,7 @@ struct dsp_file_hdr {
>         u32  version_data_offset;       /* Offset were scrambled version data begins. */
>         u32  version_data_size; /* Size, in words, of scrambled version data. */
>         u32  nDspImages;        /* Number of DSP images in file. */
> -} __attribute__ ((packed));
> +} __packed;
>
>  struct dsp_image_info {
>         u32  coff_date;         /* Date/time when DSP Coff image was built. */
> @@ -110,7 +110,7 @@ struct dsp_image_info {
>         u32  version;           /* Embedded version # of DSP code. */
>         unsigned short checksum;        /* Dsp File checksum */
>         unsigned short pad1;
> -} __attribute__ ((packed));
> +} __packed;
>
>  void card_bootload(struct net_device *dev)
>  {
> --
> 1.9.3
>



-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
