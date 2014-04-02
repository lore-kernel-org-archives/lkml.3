Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161063AbaDBXhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:37:21 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62058 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbaDBXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:37:18 -0400
Message-ID: <533C9F2A.9000102@gmail.com>
Date: Thu, 03 Apr 2014 01:37:14 +0200
From: Sherif <silentquote@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed Breaking long lines and
 strings style rule
References: <1396480678-32036-1-git-send-email-shehabaldin.sherif@gmail.com> <1396480892.32040.17.camel@joe-AO722>
In-Reply-To: <1396480892.32040.17.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

done and sent in a new mail.

BTW regarding "Alignment should match open parenthesis" rule, It's 
missing from Documentation/CodingStyle

On 04/03/2014 01:21 AM, Joe Perches wrote:
> On Thu, 2014-04-03 at 01:17 +0200, Sherif Shehab Aldin wrote:
>> Fixed coding style rule "Breaking long lines and strings" for hfa384x_usb.c
>
> Please use "scripts/checkpatch.pl --strict" on patches
> to files in drivers/staging.
>
> CHECK: Alignment should match open parenthesis
> #75: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:646:
> +	pr_debug("cmdresult:status=0x%04x resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
> +			result->status, result->resp0,
>
> CHECK: Alignment should match open parenthesis
> #99: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:1383:
> +	pr_debug("cmdreq: cmd=0x%04x parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
> +			cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);
>
> CHECK: Alignment should match open parenthesis
> #109: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2019:
> +	netdev_info(hw->wlandev->netdev,
> +			"Download %d bytes to flash @0x%06x\n", len, daddr);
>
> CHECK: Alignment should match open parenthesis
> #120: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2030:
> +	netdev_warn(hw->wlandev->netdev,
> +			"dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
>
> CHECK: Alignment should match open parenthesis
> #133: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2065:
> +			netdev_err(hw->wlandev->netdev,
> +					"download(NV,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
>
> CHECK: Alignment should match open parenthesis
> #154: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2354:
> +	netdev_info(hw->wlandev->netdev, "Writing %d bytes to ram @0x%06x\n",
> +			len, daddr);
>
> CHECK: Alignment should match open parenthesis
> #164: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2465:
> +				netdev_err(hw->wlandev->netdev,
> +						"pdrlen invalid=%d\n", pdrlen);
>
> CHECK: Alignment should match open parenthesis
> #174: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:2788:
> +		netdev_err(hw->wlandev->netdev,
> +				"submit_tx_urb() failed, error=%d\n", ret);
>
> CHECK: Alignment should match open parenthesis
> #195: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:4143:
> +			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
> +					pdrcode);
>
> CHECK: Alignment should match open parenthesis
> #202: FILE: drivers/staging/wlan-ng/hfa384x_usb.c:4148:
> +			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
> +					pdrcode);
>
> total: 0 errors, 2 warnings, 10 checks, 127 lines checked
>
>
