Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaC0TzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:55:06 -0400
Received: from plane.gmane.org ([80.91.229.3]:57380 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbaC0TzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:55:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Reimar =?utf-8?b?RMO2ZmZpbmdlcg==?= <Reimar.Doeffinger@gmx.de>
Subject: Re: [PATCH] cdrom.c: Only read a =?utf-8?b?Y2Ryb21fbXNmMA==?= struct from userspace.
Date: Thu, 27 Mar 2014 19:48:46 +0000 (UTC)
Message-ID: <loom.20140327T204517-831@post.gmane.org>
References: <1392472391-22429-1-git-send-email-Reimar.Doeffinger@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 94.254.90.28 (Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20140319 Firefox/24.0 Iceweasel/24.4.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimar Döffinger <Reimar.Doeffinger <at> gmx.de> writes:
> That is all that is actually used, reading more just
> makes the code confusing.
> In addition also fix the header and separate documentation
> to correctly indicate which struct is expected as input.
> 
> Maybe these inconsistencies were on purpose at some point
> with the intention to improve the IOCTL interface, but
> the code has now been unchanged for years and changing
> it would break e.g. MPlayer which fills the second half
> of the cdrom_msf struck with garbage, so I believe
> that at this point it is best commit to current behaviour
> and make the whole documentation less confusing.

ping
Having one piece of documentation that is clearly utter nonsense and then a
second piece of documentation that adds a note that the first documentation
is wrong sure isn't the way to keep things.

