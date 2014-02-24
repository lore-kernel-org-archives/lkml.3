Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaBXWUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:20:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56055 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaBXWUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:20:39 -0500
Message-ID: <530BC5A4.4060803@ti.com>
Date: Mon, 24 Feb 2014 17:20:20 -0500
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Josh Triplett <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
References: <1393274296-26179-1-git-send-email-trini@ti.com>  <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>  <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com>  <1393279377.11020.66.camel@joe-AO722> <530BC209.2000708@ti.com> <1393279691.11020.69.camel@joe-AO722>
In-Reply-To: <1393279691.11020.69.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 05:08 PM, Joe Perches wrote:
> On Mon, 2014-02-24 at 17:04 -0500, Tom Rini wrote:
>> I've got this modified to a CHK and only for non-file usage.  Anything
>> else we want to talk about before I repost?
> 
> Probably not, but I'm still not convinced it's useful.
> 
> Have you found a case where it's currently specified
> but not useful?

Well, U-Boot and the kernel both share the dubious to incorrect __packed
horror of cros_ec things (see include/linux/mfd/cros_ec_commands.h).

If this is really not seen as useful for the kernel, that's fine, I'll
drop it.  I mainly did this for U-Boot where we do want a bit more loud
screaming going on when people add __packed to make sure it's for a good
reason.  Wanted to be a good neighbor so to speak and see if upstream
wants it too.

-- 
Tom
