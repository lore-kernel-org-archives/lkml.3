Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaCBNtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 08:49:14 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62788 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaCBNtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 08:49:12 -0500
Message-ID: <531336D4.6030104@gmail.com>
Date: Sun, 02 Mar 2014 14:49:08 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Richard Weinberger <richard@nod.at>, linux-media@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-fimc: Remove reference to outdated macro
References: <1392199729.23759.20.camel@x220>
In-Reply-To: <1392199729.23759.20.camel@x220>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 11:08 AM, Paul Bolle wrote:
> The Kconfig symbol S5P_SETUP_MIPIPHY was removed in v3.13. Remove a
> reference to its macro from a list of Kconfig options.
>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> See commit e66f233dc7f7 ("ARM: Samsung: Remove the MIPI PHY setup
> code"). Should one or more options be added to replace
> S5P_SETUP_MIPIPHY? I couldn't say. It's safe to remove this one anyway.

Thanks, patch applied.

There has been also a related patch posted for the MIPI CSIS/DSIM PHY
driver: http://www.spinics.net/lists/linux-samsung-soc/msg26773.html

>   Documentation/video4linux/fimc.txt | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
> index e51f1b5..7d6e160 100644
> --- a/Documentation/video4linux/fimc.txt
> +++ b/Documentation/video4linux/fimc.txt
> @@ -151,9 +151,8 @@ CONFIG_S5P_DEV_FIMC1  \
>   CONFIG_S5P_DEV_FIMC2  |    optional
>   CONFIG_S5P_DEV_FIMC3  |
>   CONFIG_S5P_SETUP_FIMC /
> -CONFIG_S5P_SETUP_MIPIPHY \
> -CONFIG_S5P_DEV_CSIS0     | optional for MIPI-CSI interface
> -CONFIG_S5P_DEV_CSIS1     /
> +CONFIG_S5P_DEV_CSIS0  \    optional for MIPI-CSI interface
> +CONFIG_S5P_DEV_CSIS1  /

--
Regards,
Sylwester
