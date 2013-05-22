Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3EVJC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:02:26 -0400
Received: from gatzka.org ([85.214.228.118]:39488 "EHLO mail.gatzka.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3EVJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:02:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 May 2013 10:52:37 +0200
From: Stephan Gatzka <stephan.gatzka@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call =?UTF-8?Q?fw=5Fiso=5Fresource=5Fmange=28=2E=2E?=
 =?UTF-8?Q?=29=20=28core-iso=2Ec=29=20does=20not=20return?=
Reply-To: stephan.gatzka@gmail.com
Mail-Reply-To: stephan.gatzka@gmail.com
In-Reply-To: <519BF0DB.6040108@hurleysoftware.com>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
 <519BA6AC.1080600@hurleysoftware.com>
 <62922216e6007f9ef83956e0ca202644@gatzka.org>
 <20130521235329.48ba65e2@stein> <519BF0DB.6040108@hurleysoftware.com>
Message-ID: <1c680aea58e7923c02b88a41c1b2bd7c@gatzka.org>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> An important note with case b) is that Ralf (the original reporter) was
> running 3.4.something.  I'm aware that some work has gone into 
> workqueue
> locks in 3.9 and 3.10. I asked Ralf if he could reproduce on a more
> recent kernel but never heard back. Maybe these are two different 
> problems
> (ie, a failure to guarantee forward progress on a single workqueue and
> a straightforward deadlock when using two wqs)?
> 
> Stephan Gatzka,
> what kernel version did you instrument and reproduce this with?
> 

Ralf and I are working together on the same system. It's kernel 3.4.28, 
patched with Xenomai 2.6.1.

Regards,

Stephan
