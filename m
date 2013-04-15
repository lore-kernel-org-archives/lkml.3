Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3DOH07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:26:59 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:58599 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753526Ab3DOH06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:26:58 -0400
Date: Mon, 15 Apr 2013 10:26:48 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: David Miller <davem@davemloft.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, dcbw@redhat.com
Subject: Re: [PATCH] net: usb: active URB submitted multiple times
In-Reply-To: <20130412.151824.2029469075886743722.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1304151017230.3010@bender.nucleusys.com>
References: <20130410.232241.1038793023507666278.davem@davemloft.net> <alpine.DEB.2.02.1304110956110.4237@fry> <alpine.DEB.2.02.1304112156520.4309@fry> <20130412.151824.2029469075886743722.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013, David Miller wrote:

> When submitting a new version of a patch, you must list what changed 
> from the previous version after the "---" delimiter rather than having 
> people try and guess.

Got it.  However, i've already spammed you, Sarah and two major mailing 
lists so i assume people are a bit tired of my clumsy attempts.  Shall i 
start a new mail thread with what i hope is going to be the final patch, 
or continue this one, messy as it is?

>> +T:	git git://petkan@git.code.sf.net/p/pegasus2/git
>
> There is no way that specifying your GIT login in this URL meant for 
> public use is correct, or is it?

Oops, good catch.  A left over from the SSH URL.
