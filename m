Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3KOJ6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:58:48 -0500
Received: from mail.southpole.se ([37.247.8.11]:45681 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589Ab3KOJ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:58:40 -0500
Message-ID: <5285F085.5060105@southpole.se>
Date: Fri, 15 Nov 2013 10:59:33 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH 13/17] openrisc: Refactor or32_early_setup()
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-14-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-14-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 09519-06645
X-Assp-Session: 7F739AE75018 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 08:42 PM, Geert Uytterhoeven wrote:
>    - Change fdt pointer (passed from head.S) from unsigned int to void *,
>      which allows to kill a cast, and makes it compatible with __dtb_start.
>    - Use pr_info(),
>    - Extract common part.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: linux@lists.openrisc.net

Thanks, I'll take this one directly into the OpenRISC tree.

/Jonas
