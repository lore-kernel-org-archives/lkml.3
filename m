Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaJBUC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:02:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43554 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751442AbaJBUC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:02:26 -0400
Message-ID: <542DAF4F.1020701@free-electrons.com>
Date: Thu, 02 Oct 2014 22:02:23 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: vgupta@synopsys.com, richard@nod.at, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARC: [plat-arcfpga]: remove unused Kconfig params
References: <1412157557-6975-1-git-send-email-michael.opdenacker@free-electrons.com> <1412158326.15281.2.camel@x220>
In-Reply-To: <1412158326.15281.2.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for reviewing my patch!

On 10/01/2014 12:12 PM, Paul Bolle wrote:
> On Wed, 2014-10-01 at 11:59 +0200, Michael Opdenacker wrote:
>> This removes the ARC_BOARD_ANGEL4 and ARC_BOARD_ML509
>> Kconfig parameters which are no longer used anywhere
>> in the source code and Makefiles.
>>
>> This also updates a comment refering to these parameters.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
> See commit 774b689502d4 ("ARC: [arcfpga] Get rid of ARC_BOARD_ANGEL4 and
> ARC_BOARD_ML509") in linux-next since yesterday.

Great. Happy to drop my patch then!

>
>>  arch/arc/plat-arcfpga/Kconfig | 13 -------------
>>  1 file changed, 13 deletions(-)
>>
>> diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
>> index b9f34cf55acf..3f6814aa97ac 100644
>> --- a/arch/arc/plat-arcfpga/Kconfig
>> +++ b/arch/arc/plat-arcfpga/Kconfig
>> @@ -12,23 +12,10 @@ menuconfig ARC_PLAT_FPGA_LEGACY
>>  	help
>>  	  Support for ARC development boards, provided by Synopsys.
>>  	  These are based on FPGA or ISS. e.g.
>> -	  - ARCAngel4
>> -	  - ML509
>>  	  - MetaWare ISS
> It doesn't follow from the fact that these Kconfig symbols are unused
> that this help text is now incorrect. How did you establish that?

Oops, you're definitely right. Pfooh, starting to make the confusion
between data and metadata... scary.

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

