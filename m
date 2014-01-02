Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaABCw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 21:52:58 -0500
Received: from mail.wdtv.com ([66.118.69.84]:59224 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaABCw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 21:52:57 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect failed
Date: Wed, 1 Jan 2014 21:52:54 -0500
Cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org
References: <201401011752.00267.gheskett@wdtv.com> <201401012140.09972.gheskett@wdtv.com> <52C4D36B.9080507@infradead.org>
In-Reply-To: <52C4D36B.9080507@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201401012152.55180.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 January 2014, Randy Dunlap wrote:
>On 01/01/14 18:40, Gene Heskett wrote:
>> On Wednesday 01 January 2014, Gene Heskett wrote:
>>> On Wednesday 01 January 2014, Jason Cooper wrote:
>> Can you please repost that X64 default configuration "make" line, that
>> message seems to have encountered my expiry rules.
>> 
>> Thanks Jason.
>
>Jason said:
>$ make x86_64_defconfig
>[in http://marc.info/?l=linux-kernel&m=138829693820368&w=2 ]
>
>
>I would have said:
>$ make ARCH=x86_64 defconfig

Didn't take but 2 or 3 seconds for your version, thanks Randy.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

Never try to teach a pig to sing.  It wastes your time and annoys the pig.
		-- Lazarus Long, "Time Enough for Love"
A pen in the hand of this president is far more
dangerous than 200 million guns in the hands of
         law-abiding citizens.
