Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbaFKP6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:58:44 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54241 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbaFKP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:58:41 -0400
Message-ID: <53987CAD.2010306@6wind.com>
Date: Wed, 11 Jun 2014 17:58:37 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 3.15.0 release
References: <20140610103712.57d0b1ad@nehalam.linuxnetplumber.net>	<53986B68.5020401@6wind.com> <20140611083907.3a3cab96@nehalam.linuxnetplumber.net>
In-Reply-To: <20140611083907.3a3cab96@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/06/2014 17:39, Stephen Hemminger a écrit :
> On Wed, 11 Jun 2014 16:44:56 +0200
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>
>> Le 10/06/2014 19:37, Stephen Hemminger a écrit :
>>> Time for the release of iproute2 for 3.15
>>>
>>> The main new features are:
>>>     * ss gets more attention
>>>     * Support for HHF qdisc
>>>     * Updates to bridge command
>>>     * Lots of vxlan related changes
>>>     * Lots of little corrections and build fixes
>>>
>>> Source:
>>>     http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.15.0.tar.gz
>>>
>>> Repository:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
>> It seems that you have pushed the tag, but not the tagged commit
>> (ce7aff3b8d0bb55321af2dbaa2f911319fdcc76b). In fact, I don't see the tag in the
>> branch master.
>
> try now
>
Works, thank you.
You gave a shortlog in the announcement, it is done between which tags?
If I run 'git shortlog v3.14.0..v3.15.0', the output is shorter than yours.
