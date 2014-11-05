Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaKEHon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:44:43 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49850 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaKEHok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:44:40 -0500
Message-ID: <5459D576.3010000@gmail.com>
Date: Wed, 05 Nov 2014 08:44:54 +0100
From: Roberto Medina <robertoxmed@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, Joe Perches <joe@perches.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: eth: realtek: atp: checkpatch errors and warnings
 corrected
References: <1415039073-20164-1-git-send-email-robertoxmed@gmail.com> <1415040686.17743.31.camel@perches.com> <5457D2DF.5000508@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D1C9E71E4@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9E71E4@AcuExch.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 11:19 AM, David Laight wrote:
>
> That code (and all the ones below) are gibberish, neither the old or new
> sequences make any sense.
>

Thank you for your feedback I did it again and objdiff doesn't show any 
changes (if I'm not mistaken).

> Almost as though you used the wrong instruction set!
>
> 	David

diff -Nurd 
/home/vov/Git/linux-next/.tmp_objdiff/a641d0e/drivers/net/ethernet/realtek/atp.dis 
/home/vov/Git/linux-next/.tmp_objdiff/5f19b70/drivers/net/ethernet/realtek/atp.dis
--- 
/home/vov/Git/linux-next/.tmp_objdiff/a641d0e/drivers/net/ethernet/realtek/atp.dis 
2014-11-05 08:38:49.244100507 +0100
+++ 
/home/vov/Git/linux-next/.tmp_objdiff/5f19b70/drivers/net/ethernet/realtek/atp.dis 
2014-11-05 08:39:14.654101606 +0100
@@ -1357,7 +1357,7 @@

  Disassembly of section .bss:

-00000000 <num_tx_since_rx.36127>:
+00000000 <num_tx_since_rx.36172>:
  :	00 00                	add    %al,(%eax)
  	...

Thanks,

Roberto

