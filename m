Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaIOTlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:41:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54593 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbaIOTln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:41:43 -0400
Date: Mon, 15 Sep 2014 12:41:41 -0700
From: Darren Hart <dvhart@infradead.org>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/13] eeepc-laptop: coding style: add curly braces
 around else compound
Message-ID: <20140915194141.GA62440@vmdeb7>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
 <1410563212-31565-4-git-send-email-fransklaver@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410563212-31565-4-git-send-email-fransklaver@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 01:06:42AM +0200, Frans Klaver wrote:
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>

Hi Frans,

Please merge the 3 coding style fixes into one patch. There is no functional
change here, and each of the 3 is obvious. Please include a simple commit
message to the effect of:

"
eeepc-laptop: Coding style cleanup

Correct white space and brace usage per Documentation/CodingStyle.
"

As a point of policy, I will not merge commits without a message, no matter how
trivial.

Thanks,

> ---
>  drivers/platform/x86/eeepc-laptop.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 702fcbb..9d8dff9 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -1425,8 +1425,9 @@ static int eeepc_acpi_add(struct acpi_device *device)
>  		result = eeepc_backlight_init(eeepc);
>  		if (result)
>  			goto fail_backlight;
> -	} else
> +	} else {
>  		pr_info("Backlight controlled by ACPI video driver\n");
> +	}
>  
>  	result = eeepc_input_init(eeepc);
>  	if (result)
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Darren Hart
Intel Open Source Technology Center
