Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbbA0V0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:26:54 -0500
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:56980 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759953AbbA0V0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:26:52 -0500
Message-ID: <54C8029A.5080500@linicks.net>
Date: Tue, 27 Jan 2015 21:26:50 +0000
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wow.

On my amd64 it usually takes about 19 minutes to build my bespoke 
kernel.  After I downloaded/untarball/setup issued 'make' and then 
watched TV for a bit.  Bloody hell, next time I looked it was built... 
in about 13 minutes.  I suspected something was wrong, as I added new 
ipsets classes tonight prior to this and had to double check.

Nope, all hunky dory :)

So, I just updated my lowly Samsung notebook bespoke build - normal 
build time on this is about 57 minutes - 3.18.4 is now < 45 minutes.

Great stuff - I dunno what you guys changed, but it's good.

Many thanks,

Nick
P.S. also the Intel driver is fixed toboot too :)
-- 
Q. What's the difference between a duck and an elephant?
A. You can't get down off an elephant.
