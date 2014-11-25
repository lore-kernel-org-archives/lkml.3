Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaKYWLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:11:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55922 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751826AbaKYWLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:11:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Huang Rui <ray.huang@amd.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Fixed a typo comment
Date: Tue, 25 Nov 2014 23:33:05 +0100
Message-ID: <7348229.oIVhWiAvoM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416830198-2414-1-git-send-email-ray.huang@amd.com>
References: <1416830198-2414-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 24, 2014 07:56:38 PM Huang Rui wrote:
> Signed-off-by: Huang Rui <ray.huang@amd.com>

Queued up for 3.19-rc1, thanks!

> ---
>  drivers/acpi/device_pm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
> index 7db1931..076af81 100644
> --- a/drivers/acpi/device_pm.c
> +++ b/drivers/acpi/device_pm.c
> @@ -201,7 +201,7 @@ int acpi_device_set_power(struct acpi_device *device, int state)
>  	 * Transition Power
>  	 * ----------------
>  	 * In accordance with the ACPI specification first apply power (via
> -	 * power resources) and then evalute _PSx.
> +	 * power resources) and then evaluate _PSx.
>  	 */
>  	if (device->power.flags.power_resources) {
>  		result = acpi_power_transition(device, state);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
