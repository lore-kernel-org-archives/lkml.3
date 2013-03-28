Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3C1OtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:49:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41246 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3C1OtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:49:23 -0400
Message-ID: <51545870.4010209@wwwdotorg.org>
Date: Thu, 28 Mar 2013 08:49:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Grant Likely <grant.likely@secretlab.ca>, Olof Johansson <olof@lixom.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.9-rc1 regression in arm dtb build
References: <20130306193332.GA6022@amd.pavel.ucw.cz> <5137C404.9060902@wwwdotorg.org> <20130307144506.GB7344@amd.pavel.ucw.cz> <5138FDAE.8060202@wwwdotorg.org> <20130311050546.GA21863@quad.lixom.net> <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com> <20130328092916.GA11187@amd.pavel.ucw.cz>
In-Reply-To: <20130328092916.GA11187@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 03:29 AM, Pavel Machek wrote:
...
> There's change that makes it pretty much impossible to build dtbs
> reliably between different kernel versions, because it leaves old dtbs
> around, and they survive even make clean.

One question here: Presumably the dtbs don't survive "make clean" if you
run that right after building the dtbs, but only if you check out a new
kernel version before running clean? Or is that not the case?
