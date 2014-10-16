Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaJPKu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:50:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaJPKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:50:57 -0400
Date: Thu, 16 Oct 2014 12:50:54 +0200
From: Luis Henriques <luis.henriques@canonical.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>, kernel-team@lists.ubuntu.com,
        Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.13 163/163] lzo: check for length overrun in variable
 length encoding.
Message-ID: <20141016105054.GA5467@hercules>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
 <1412888588-26755-164-git-send-email-kamal@canonical.com>
 <20141010053048.GD3594@1wt.eu>
 <1413221463.11421.30.camel@fourier>
 <20141014015233.GA24799@kroah.com>
 <20141014085841.GA7710@hercules>
 <543F7D76.1000208@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <543F7D76.1000208@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:10:30AM +0200, Jiri Slaby wrote:
> On 10/14/2014, 10:58 AM, Luis Henriques wrote:
> > Could you please provide us with examples of commits in one of our
> > extended stable trees that is not on any other public release at
> > kernel.org?
> 
> Hi, from 3.12.y, for example:
> commit 48e8cad86bb1241c08bdaa80db022c25068ff8e0
> Author: Jiri Slaby <jslaby@suse.cz>
> Date:   Mon Jul 14 15:20:17 2014 +0200
> 
>     Revert "aio: fix kernel memory disclosure in io_getevents()
> introduced in v3.10"
> 
>     This reverts commit 0e2e24e5dc6eb6f0698e9dc97e652f132b885624, which
>     was applied twice mistakenly. The first one is
>     bee3f7b8188d4b2a5dfaeb2eb4a68d99f67daecf.
> 
> 
> Or any other patch without the "commit upstream" line. This may also
> happen where there is no way of backporting a fix to the stable tree due
> to later changes. Instead, a simple fix is applied, but it has no
> connection to the original commit but the reference.
> 

Thank you for your reply Jiri, but I believe you're referring to
commits that are in stable kernels and that are not on Linus tree.  I
do understand that these are required occasionally for the reasons you
stated above, and they are usually provided by subsystem maintainers.

However, the initial discussion was about commits that are not in a
public release (e.g. a Linus rc kernel) at kernel.org.

Cheers,
--
Luís
