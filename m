Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbaFTUeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:34:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742AbaFTUeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:34:07 -0400
Message-ID: <53A49ABB.8070704@suse.cz>
Date: Fri, 20 Jun 2014 22:34:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kamal Mostafa <kamal@canonical.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH] Makefile: version.h macros KERNEL_EXTRAVERSION, LINUX_EXTRAVERSION_CODE
References: <1403189058-24103-1-git-send-email-kamal@canonical.com>	 <53A4016E.9040108@suse.cz> <1403279278.14743.64.camel@fourier>
In-Reply-To: <1403279278.14743.64.camel@fourier>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 20.6.2014 17:47, Kamal Mostafa napsal(a):
> On Fri, 2014-06-20 at 11:39 +0200, Michal Marek wrote:
>> Why don't you guys simply increment the third digit in the extended
>> stable tree and get support for KERNEL_VERSION() for free? You always
>> start after the respective stable branch has reached EOL, don't you?
> 
> Yes, we only start after the stable branch has reached EOL.
> 
> We don't increment the third integer for the extended-stable branches
> (we add a fourth integer instead) in order to avoid the possibility of a
> collision if Greg KH were to ever release a "special" post-EOL version
> of one of his branches.

The maintainers of 2.6.32.y, 3.2.y and 3.12.y have taken that risk and
it has been working fine so far ;-).

Michal
