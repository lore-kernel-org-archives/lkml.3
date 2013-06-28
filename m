Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3F1Fte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:49:34 -0400
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:15459 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705Ab3F1Ftd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:49:33 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'sboyd@codeaurora.org'" <sboyd@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 13:49:28 +0800
Subject: 
Thread-Index: Ac5zw0DWWyN963h+S5qFTNGI7gLoNQ==
Message-ID: <35FD53F367049845BC99AC72306C23D19441BF5868@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sboy,

I don't know who should I send this mail to .
If you are not the right person, please forward 
To the right responsible person , Thank you !

I have a question about msm kernel code :

File: Arch/arm/msm/memory.c

reserve_memory_for_mempools()
it call memblock_remove() directly,
I think it's not safe sometimes ,
Should use arm_memblock_steal() function or some other similar
Function to make sure the removed memory is not reserved by memblock driver,
In case the removed memory is reserved by some driver.


Thanks 


Yalin.Wang
Software Engineer 
OS Kernel&Graphics
 
Sony Mobile Communications
Tel: +86 10 5966 9819
Phone: 18610323092
Address: No.16 Guangshun South Street, Chaoyang, Beijing, P.R.C.

sonymobile.com
  



