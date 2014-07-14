Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbaGNXCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 19:02:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53253 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749AbaGNXCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 19:02:50 -0400
X-Sasl-enc: 8avtEqAAKSsD36knAWlBTTz9J+Tzo2cOUleMSug2C2tq 1405378969
Date: Mon, 14 Jul 2014 20:02:43 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, ibm-acpi@hmh.eng.br,
        matthew.garrett@nebula.com
Subject: Re: [PATCH] drivers/platform/x86/thinkpad_acpi.c: don't test
 unsigned int for negativity
Message-ID: <20140714230243.GD5939@khazad-dum.debian.net>
References: <1405378581-12146-1-git-send-email-andrey.krieger.utkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405378581-12146-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Andrey Utkin wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80231
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> ---
>  drivers/platform/x86/thinkpad_acpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index d82f196..4d59b09 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -6144,7 +6144,7 @@ static int brightness_set(unsigned int value)
>  {
>  	int res;
>  
> -	if (value > bright_maxlvl || value < 0)
> +	if (value > bright_maxlvl)
>  		return -EINVAL;
>  
>  	vdbg_printk(TPACPI_DBG_BRGHT,

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
