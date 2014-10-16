Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaJPIKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:10:39 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33570 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaJPIKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:10:35 -0400
Message-ID: <543F7D76.1000208@suse.cz>
Date: Thu, 16 Oct 2014 10:10:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.13 163/163] lzo: check for length overrun in variable
 length encoding.
References: <1412888588-26755-1-git-send-email-kamal@canonical.com> <1412888588-26755-164-git-send-email-kamal@canonical.com> <20141010053048.GD3594@1wt.eu> <1413221463.11421.30.camel@fourier> <20141014015233.GA24799@kroah.com> <20141014085841.GA7710@hercules>
In-Reply-To: <20141014085841.GA7710@hercules>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014, 10:58 AM, Luis Henriques wrote:
> Could you please provide us with examples of commits in one of our
> extended stable trees that is not on any other public release at
> kernel.org?

Hi, from 3.12.y, for example:
commit 48e8cad86bb1241c08bdaa80db022c25068ff8e0
Author: Jiri Slaby <jslaby@suse.cz>
Date:   Mon Jul 14 15:20:17 2014 +0200

    Revert "aio: fix kernel memory disclosure in io_getevents()
introduced in v3.10"

    This reverts commit 0e2e24e5dc6eb6f0698e9dc97e652f132b885624, which
    was applied twice mistakenly. The first one is
    bee3f7b8188d4b2a5dfaeb2eb4a68d99f67daecf.


Or any other patch without the "commit upstream" line. This may also
happen where there is no way of backporting a fix to the stable tree due
to later changes. Instead, a simple fix is applied, but it has no
connection to the original commit but the reference.

thanks,
-- 
js
suse labs
