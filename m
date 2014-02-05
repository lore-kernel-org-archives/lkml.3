Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaBEPKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:10:21 -0500
Received: from mail.wdtv.com ([66.118.69.84]:52833 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaBEPKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:10:20 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Subject: Re: possible viri in tarballs?
Date: Wed, 5 Feb 2014 10:10:07 -0500
References: <201402050915.34607.gheskett@wdtv.com> <20140205163528.5b67d8e0@mdontu-l>
In-Reply-To: <20140205163528.5b67d8e0@mdontu-l>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201402051010.07539.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014, Mihai Donțu wrote:
>On Wed, 5 Feb 2014 09:15:34 -0500 Gene Heskett wrote:
>> I recently brought a daily system scan by clamscan back to life, and
>> its emailing me this:
>> 
>> /home/gene/src/linux-3.8.2/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL
>> FOUND /home/gene/src/linux-3.12.6/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL
>> FOUND /home/gene/src/linux-3.8.3/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL
>> FOUND /home/gene/src/linux-3.12.9/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL
>> FOUND /home/gene/src/linux-3.4.36/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL
>> FOUND /home/gene/src/linux-3.0.69/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL
>> FOUND /home/gene/src/linux-3.2.40/Documentation/usb/gadget_multi.txt:
>> MBL_400944.UNOFFICIAL FOUND
>> 
>> Repeat for several other kernel trees.
>> FP or ??
>
>Most likely a FP, but try: https://www.virustotal.com/

I'll report it as an FP then.  I didn't know about that site. thanks.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

