Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162359AbaDCGhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:37:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:33576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162301AbaDCGhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:37:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,784,1389772800"; 
   d="scan'208";a="513888097"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [HELP] How to use ftrace to learn how a function is ivoked?
Thread-Topic: [HELP] How to use ftrace to learn how a function is ivoked?
Thread-Index: Ac9PBgAhos6+ZE8TTkmGFV4GZKg9Hg==
Date: Thu, 3 Apr 2014 06:36:57 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A01AA980B@SHSMSX103.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s336bBd4015794

Hi, All,
I have a question for ftrace usage. It is that if I have a function A, then I want to 
know how function A is ivoked?
I know ftrace can show me what sub-functions that A called by below steps:
	# echo function_graph > current_tracer
¡¡¡¡# echo function_A > set_graph_function
	# cat trace
Then a call stack will show what functions A has called. But sometimes I want to 
know how A is called. Is there a method to do this? Please help me!

Regards and Thanks!
Du, Changbin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
