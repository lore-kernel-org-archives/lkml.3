Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3ARO16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:27:58 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:61247 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3ARO15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:27:57 -0500
Message-ID: <50F95B84.2010802@synopsys.com>
Date: Fri, 18 Jan 2013 19:56:12 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/76] ARC: Checksum/byteorder/swab routines
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-10-git-send-email-vgupta@synopsys.com> <201301181421.09458.arnd@arndb.de>
In-Reply-To: <201301181421.09458.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 07:51 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> TBD: do_csum still needs to be written in asm
> Do you actually expect a lot of improvement in do_csum?
> I would hope that gcc can actually generate a pretty
> good version of it, unless you have some 64-bit add-with-carry
> instruction or something else that you could make use of.

We do have 32bit add-with-carry and it has it's own set of micro-architectural
hazards and stalls which deserve careful insn scheduling. So yes the mileage would
vary but certainly deserves a try.

>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks,
-Vineet

