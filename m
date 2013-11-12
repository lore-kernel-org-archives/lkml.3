Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3KLIcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:32:36 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3916 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345Ab3KLIca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:32:30 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5281E797.9030101@broadcom.com>
Date: Tue, 12 Nov 2013 09:32:23 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Michael Opdenacker" <michael.opdenacker@free-electrons.com>,
        trivial@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of
 "the the "
References: <1384233016-15188-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1384233016-15188-1-git-send-email-michael.opdenacker@free-electrons.com>
X-WSS-ID: 7E9F38F44RS7225641-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 06:10 AM, Michael Opdenacker wrote:
> Fix all occurrences of "the the " in the source code,
> comments and documentation.
>
> The replacement couldn't be automated because sometimes
> the first "the" was meant to be another word.
>
> Example: "according the the"
> meaning: "according to the"
>
> Note that I sometimes took the opportunity to fix
> other spelling issues or typos in the same sentences.
> I also fixed a few checkpatch errors in the same
> lines.
>
> This is an update to the patch sent on Sep. 12, 2013

Better put this kind of info below the signed-off-by line. Or even 
better use the message-id of that patch in the 'In-Reply-To:' field that 
git-send-email prompts for.

For driver change mentioned below:
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
so here: 'This is an update to the patch sent on Sep. 12, 2013'
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c                 | 2 +-


