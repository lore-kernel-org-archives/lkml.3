Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaKFNTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:19:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaKFNTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:19:36 -0500
Message-ID: <545B755D.4090900@draigBrady.com>
Date: Thu, 06 Nov 2014 14:19:25 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Tournoij <martin@arp242.net>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] The SIGINFO signal from BSD
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com> <545A7B00.1040309@gmail.com> <20141105201404.GH27083@thunk.org> <1415225591.3444747.187568145.134CEE91@webmail.messagingengine.com>
In-Reply-To: <1415225591.3444747.187568145.134CEE91@webmail.messagingengine.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 11:13 PM, Martin Tournoij wrote:
> On Wed, Nov 5, 2014, at 20:31, Austin S Hemmelgarn wrote:
>> The people to talk to about that for the core 
>> utilities on Linux would be the maintainers of the GNU coreutils, or 
>> whatever your distribution might use in their place (I think it's very 
>> unlikely that busybox or toybox would implement it however).
> 
> Well, if the kernel doesn't provide the feature, then we can be sure it
> will never be implemented :-)
> I thought this was a good place to start asking,, and even if GNU
> coreutils opt to not implement this for whatever reasons, other
> applications still can (mine will!)

GNU coreutils dd will already support SIGINFO if available
(and if dd is recompiled with appropriate headers).
dd currently emulates that using SIGUSR1 though as you say
that's awkward to support robustly, and there has been
a recent GNU coreutils change in relation to that:
http://git.sv.gnu.org/gitweb/?p=coreutils.git;a=commit;h=27d2c738

I like the idea of making SIGINFO generally available
and GNU coreutils at least would add extra handling
to cp etc. if that was the case.

thanks,
Pádraig.
