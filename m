Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaDYNCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:02:42 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51245 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaDYNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:02:40 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <535A5CEE.40008@roeck-us.net>
Date: Fri, 25 Apr 2014 06:02:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, thomas.mingarelli@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: watchdog: Add an usage note on hpwdt with hp-asrd
References: <1398423149-5028-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398423149-5028-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 03:52 AM, Masanari Iida wrote:
> An agent software called hp-asrd from Hewlett Packard
> updates same iLO watchdog timer as hpwdt does update.
> So they can not be uses simultaneously.
> Add this usage note in hpwdt.txt.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>   Documentation/watchdog/hpwdt.txt | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/watchdog/hpwdt.txt b/Documentation/watchdog/hpwdt.txt
> index 9488078..719c38d 100644
> --- a/Documentation/watchdog/hpwdt.txt
> +++ b/Documentation/watchdog/hpwdt.txt
> @@ -89,7 +89,8 @@ Last reviewed: 06/02/2009
>
>   	Hypertransport/CSI Error       31h
>
> -
> +hpwdt can not work as expected if hp-asrd is running simultaneously.
> +Because both hpwdt and hp-asrd update same iLO watchdog timer.
>

How about adding a note here explaining that hp-asrd is a user space application
from HP (assuming that is what it is) ?

Guenter


