Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3JIHSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:18:15 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:16099 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867Ab3JIHSM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:18:12 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Oct 2013 03:18:11 EDT
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Will Deacon'" <will.deacon@arm.com>
CC: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Oct 2013 15:08:05 +0800
Subject: SDIV / UDIV  Question
Thread-Topic: SDIV / UDIV  Question
Thread-Index: Ac7Evkz2wQunAGFERXCJXNbvarEymQ==
Message-ID: <35FD53F367049845BC99AC72306C23D1014D1A0971AC@CNBJMBX05.corpusers.net>
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

Hi  Will

I have a question about sdiv/ udiv  instructions :
In  armv7 A/R  TRM, it said sdiv/udiv will cause 
Divide by zero as undefined exception or just return zero
(decided by implementation) .

So  in kernel ,  should we need register a undef hook to 
Get this undef exception and send SIGFPE to user space
Process ?  


Thanks 




Yalin.Wang
Software Engineer 
OS Kernel&Graphics
 
Sony Mobile Communications
Tel: +86 10 5966 9819
Phone: 18610323092
Address: No.16 Guangshun South Street, Chaoyang, Beijing, P.R.C.

sonymobile.com
  
 


