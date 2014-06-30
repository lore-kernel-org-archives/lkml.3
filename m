Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbaF3SvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:51:04 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:58250 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaF3SvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:51:03 -0400
Message-ID: <53B1B194.3060907@linicks.net>
Date: Mon, 30 Jun 2014 19:51:00 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
References: <53AE9058.50902@linicks.net> <20140628101240.GA6357@pd.tnic> <53AE9863.6050102@linicks.net> <53AE9F0B.1080207@linicks.net> <20140628122322.GC4373@pd.tnic> <53AEBE75.9070301@linicks.net> <53B063BC.4040200@linicks.net> <20140629194403.GB12943@pd.tnic> <53B07F99.40600@linicks.net> <20140629212423.GE12943@pd.tnic> <20140630132637.GD4766@pd.tnic>
In-Reply-To: <20140630132637.GD4766@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/14 14:26, Borislav Petkov wrote:
> On Sun, Jun 29, 2014 at 11:24:23PM +0200, Borislav Petkov wrote:
>> Btw, I thought you had that gcc 4.2.x from some distro or so. Because
>> if it is in some ancient distro, one could install it in kvm and test
>> and play with it.
>
> Ok, I did dig out an ancient debian I had lying around here with gcc
> 4.1.2. The patch I pointed you at does really fix the issue. So all is
> fine and solved now. :-)

Ummm, interesting.

But is it solved?

Suppose developer a.n.other submits a patch that works with his/her GCC 
version but doesn't with some other GCC version.  I guess this will be 
picked up in GIT build tests, but that only then tells everybody to 
upgrade GCC or find a patch that fixes the issue (like you did, but I 
couldn't find it).

Is there a document or something that stipulates what is the minimum 
version[s] of GCC to build a particular version of the kernel?  If not, 
perhaps this is something that needs addressing.

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/
