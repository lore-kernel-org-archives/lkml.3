Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbaEFCqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:46:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41049 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630AbaEFCqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:46:21 -0400
Message-ID: <53684CF9.8020305@gmail.com>
Date: Tue, 06 May 2014 04:46:17 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
CC: linux-kernel@vger.kernel.org, kernel@lists.fedoraproject.org,
        andreas.utterberg@thundera.se, jwboyer@fedoraproject.org,
        sgruszka@redhat.com
Subject: Re: [PATCH] asus-nb-wmi: set wapf=4 for ASUSTeK COMPUTER INC. X75VBP
 & X550CA
References: <1398550344-3785-1-git-send-email-pomidorabelisima@gmail.com>
In-Reply-To: <1398550344-3785-1-git-send-email-pomidorabelisima@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.04.2014 00:12, poma wrote:
> Need to set wapf to 4 for ASUSTeK COMPUTER INC. X75VBP & X550CA, so that the wireless network adapter is enabled.
> 
> References:
> - asus-nb-wmi: set wapf=4 for ASUSTeK COMPUTER INC. X75VBP
> http://marc.info/?l=linux-kernel&m=139819918125110
> - Ath9k WiFi now disabled by radio killswitch
> https://bugzilla.redhat.com/show_bug.cgi?id=1089731
> 
> Reported-by: poma <pomidorabelisima@gmail.com>
> Reported-by: Andreas Utterberg <andreas.utterberg@thundera.se>
> Tested-by: poma <pomidorabelisima@gmail.com>
> Tested-by: Andreas Utterberg <andreas.utterberg@thundera.se>
> Cc: Fedora kernel development <kernel@lists.fedoraproject.org>
> Cc: Andreas Utterberg <andreas.utterberg@thundera.se>
> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> ---
>  drivers/platform/x86/asus-nb-wmi.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
> index 563f59e..d3641e0 100644
> --- a/drivers/platform/x86/asus-nb-wmi.c
> +++ b/drivers/platform/x86/asus-nb-wmi.c
> @@ -137,6 +137,15 @@ static struct dmi_system_id asus_quirks[] = {
>  	},
>  	{
>  		.callback = dmi_matched,
> +		.ident = "ASUSTeK COMPUTER INC. X550CA",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "X550CA"),
> +		},
> +		.driver_data = &quirk_asus_x401u,
> +	},
> +	{
> +		.callback = dmi_matched,
>  		.ident = "ASUSTeK COMPUTER INC. X55A",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> @@ -182,6 +191,15 @@ static struct dmi_system_id asus_quirks[] = {
>  	},
>  	{
>  		.callback = dmi_matched,
> +		.ident = "ASUSTeK COMPUTER INC. X75VBP",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "X75VBP"),
> +		},
> +		.driver_data = &quirk_asus_x401u,
> +	},
> +	{
> +		.callback = dmi_matched,
>  		.ident = "ASUSTeK COMPUTER INC. 1015E",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> 

Corentin, care to pick up this one?
https://bugzilla.redhat.com/attachment.cgi?id=892751


poma




