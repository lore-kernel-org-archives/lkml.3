Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbaBAPoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 10:44:32 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:49865 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaBAPob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 10:44:31 -0500
Message-ID: <52ED1626.7060905@ladisch.de>
Date: Sat, 01 Feb 2014 16:43:34 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove hpet vclock support
References: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
In-Reply-To: <d348afdb2f6acc41dde0381396226b69a0358f8b.1391210357.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski wrote:
> The HPET is so amazingly slow that this is barely a win.

What happens on CPUs where the TSC cannot be used for the clock?

> it scares me a tiny bit to map a piece of crappy hardware where every
> userspace program can poke at it (even if said poking is read-only).
> Let's just remove it.

So this mapping is a backdoor to bypass the restrictions on /dev/hpet?  ;-)


Regards,
Clemens
