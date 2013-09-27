Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3I0URI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:17:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40132 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab3I0URG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:17:06 -0400
Message-ID: <5245E7B1.2000408@zytor.com>
Date: Fri, 27 Sep 2013 15:16:49 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
References: <20130925001344.GA13554@redhat.com>
In-Reply-To: <20130925001344.GA13554@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 07:13 PM, Dave Jones wrote:
> This seems to have been copied from the Optiplex 990 entry above, but somoene
> forgot to change the ident text.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index f6835d8..ea2aaca 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -360,7 +360,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
>  	},
>  	{	/* Handle problems with rebooting on the Precision M6600. */
>  		.callback = set_pci_reboot,
> -		.ident = "Dell OptiPlex 990",
> +		.ident = "Dell Precision M6600",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
> 

It really is starting to feel like *ALL* Dell machines need reboot=pci?

	-hpa

