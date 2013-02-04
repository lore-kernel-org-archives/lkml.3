Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3BDAig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 19:38:36 -0500
Received: from trent.utfs.org ([94.185.90.103]:53894 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab3BDAi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 19:38:26 -0500
Date: Sun, 3 Feb 2013 16:38:21 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.7-rc7: BUG: MAX_STACK_TRACE_ENTRIES too low!
In-Reply-To: <alpine.DEB.2.01.1301271451390.7378@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1302031635410.13050@trent.utfs.org>
References: <alpine.DEB.2.01.1211271824120.7378@trent.utfs.org> <alpine.DEB.2.01.1211271916160.7378@trent.utfs.org> <1354092082.3054.19.camel@ThinkPad-T5421.cn.ibm.com> <alpine.DEB.2.01.1301121241340.7378@trent.utfs.org> <1358233164.15371.2.camel@ThinkPad-T5421.cn.ibm.com>
 <alpine.DEB.2.01.1301271451390.7378@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013 at 14:56, Christian Kujau wrote:
> Hm, is there no chance to get this into 3.8? I've been running with this 
> patch applied since 3.7-rc7 and it got rid of this 
> "MAX_STACK_TRACE_ENTRIES too low" message. I've just upgraded to 3.8-rc5 
> and it's still not in mainline :-\

Hah! I just noticed that it got merged the next day - Thanks!

Christian.
-- 
BOFH excuse #80:

That's a great computer you have there; have you considered how it would work as a BSD machine?
