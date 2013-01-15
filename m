Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3AOEEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:04:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:54923 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab3AOEED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:04:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,469,1355126400"; 
   d="scan'208";a="272045427"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wujianguo@huawei.com" <wujianguo@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linfeng@cn.fujitsu.com" <linfeng@cn.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "lliubbo@gmail.com" <lliubbo@gmail.com>,
        "jaegeuk.hanse@gmail.com" <jaegeuk.hanse@gmail.com>,
        "glommer@parallels.com" <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Topic: [PATCH v5 0/5] Add movablecore_map boot option
Thread-Index: AQHN8jfezP7hxPPawkaXDMerNaAcgJhJm6qAgABUxAD//3o84IAAtNAAgAAndAD//39VCw==
Date: Tue, 15 Jan 2013 04:04:01 +0000
Message-ID: <F1CBDF84-6A96-4D07-843F-3353E9029EE6@intel.com>
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
 <50F440F5.3030006@zytor.com>
 <20130114143456.3962f3bd.akpm@linux-foundation.org>
 <3908561D78D1C84285E8C5FCA982C28F1C97C2DA@ORSMSX108.amr.corp.intel.com>
 <50F4AF88.9090201@jp.fujitsu.com>,<f0b491ad-e520-4b32-8506-1a85a15b2924@email.android.com>
In-Reply-To: <f0b491ad-e520-4b32-8506-1a85a15b2924@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> 
>> I don't think so because user can easily get raw address by kernel
>> message in x86.
>> 

Which will fail if on some subsequent boot a DIMM fails BIST and is removed from the memory map by the BIOS which will then change all the mode boundaries for those above the failed DIMM.

-Tony