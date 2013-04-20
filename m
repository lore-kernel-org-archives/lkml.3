Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3DTE7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 00:59:40 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:37529 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3DTE7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 00:59:38 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r3K4xI4A029613, This message is released by code: ctlocs8528
From: Roger Tseng <rogerable@realtek.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "cjb@laptop.org" <cjb@laptop.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Sat, 20 Apr 2013 12:59:17 +0800
Subject: RE: [PATCH] mfd:rtsx: Support RTL8411B
Thread-Topic: [PATCH] mfd:rtsx: Support RTL8411B
Thread-Index: Ac49Dv//FRRY7kmFSQmNT+bwGsnZWwAdAn79
Message-ID: <1121E117AD4ECE49880A389A396215BB8718AE9050@rtitmbs7.realtek.com.tw>
References: <1366379562-23429-1-git-send-email-rogerable@realtek.com>,<20130419150244.GK6638@mwanda>
In-Reply-To: <20130419150244.GK6638@mwanda>
Accept-Language: zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Fri, Apr 19, 2013 at 09:52:42PM +0800, rogerable@realtek.com wrote:
>> From: Roger Tseng <rogerable@realtek.com>
>>
>> Adding support of model RTL8411B. Since the model is similar to RTL8411,
>> differences are implemented in rtl8411.c.
>>
>
>What tree is this against?
>
>regards,
>dan carpenter

It should be the mfd-next tree.

Best regards,
Roger Tseng