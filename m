Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaABCsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:48:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45658 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaABCsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:48:15 -0500
Message-ID: <52C4D36B.9080507@infradead.org>
Date: Wed, 01 Jan 2014 18:48:11 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>, Jason Cooper <jason@lakedaemon.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect failed
References: <201401011752.00267.gheskett@wdtv.com> <20140102001900.GC19878@titan.lakedaemon.net> <201401012125.55522.gheskett@wdtv.com> <201401012140.09972.gheskett@wdtv.com>
In-Reply-To: <201401012140.09972.gheskett@wdtv.com>
Content-Type: text/plain; charset=windows-1256
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 18:40, Gene Heskett wrote:
> On Wednesday 01 January 2014, Gene Heskett wrote:
>> On Wednesday 01 January 2014, Jason Cooper wrote:
> 
> Can you please repost that X64 default configuration "make" line, that 
> message seems to have encountered my expiry rules.
> 
> Thanks Jason.

Jason said:
$ make x86_64_defconfig
[in http://marc.info/?l=linux-kernel&m=138829693820368&w=2 ]


I would have said:
$ make ARCH=x86_64 defconfig


-- 
~Randy
