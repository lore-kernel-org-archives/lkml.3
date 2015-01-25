Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbbAYPzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 10:55:22 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:35019 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbAYPzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 10:55:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH v2 2/4] sh-pfc: Add emev2 pinmux support
Date: Sun, 25 Jan 2015 17:55:54 +0200
Message-ID: <3985874.o1XzLz2DsM@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150125134823.GA26657@bigcity.berto.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se> <1564701.sT8vso17XV@avalon> <20150125134823.GA26657@bigcity.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

On Sunday 25 January 2015 14:48:23 Niklas Söderlund wrote:
> Hi Laurent,
> 
> Thanks for your comments.
> 
> As note in your comments I have not grouped pins in groups where I have
> been uncertain if they can be used independently or not. I have read
> your input and made a v3 of the patch which address better grouping.
> 
> I am a bit uncertain on how to best submit the updated patch. I will
> send just v3 of 2/4 to this thread. If you wish for me to send the
> complete series fresh let me.

I'll review 2/4 v3, but the usual practice is to resend the whole series, 
especially when it's small.

> If I am to send the complete series once more do I add the 'Acked-by' to 1/4
> and 3/4 or not?

Yes, please collect the Acked-by lines in your tree and include them when you 
resend patches or send a pull request.

-- 
Regards,

Laurent Pinchart

