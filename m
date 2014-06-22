Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaFVLPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 07:15:24 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:63051 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaFVLPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 07:15:22 -0400
Message-ID: <53A6BAC5.80206@cogentembedded.com>
Date: Sun, 22 Jun 2014 15:15:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>,
        michal.simek@xilinx.com
CC: anirudh@xilinx.com, John.Linn@xilinx.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xilinx: Fix compiler warning
References: <1403432461-18296-1-git-send-email-manuel.schoelling@gmx.de>
In-Reply-To: <1403432461-18296-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/22/2014 02:21 PM, Manuel Schölling wrote:

> The time comparsion functions require arguments of type unsigned long
> instead of (signed) long.

> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

[...]

> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 60c4196..2d069a3 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -351,7 +351,6 @@ static void __init get_fs_names(char *page)
>   				continue;
>   			line++;
>
> -			/* append fsname */
>   			memmove(fsnames, line, strlen(line)+1);
>   			fsnames += strlen(fsnames)+1;
>   		} while (page != NULL);
>

   Seems like unrelated random change.

WBR, Sergei

