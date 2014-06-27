Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaF0JJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:09:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:20840 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbaF0JJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:09:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,559,1400050800"; 
   d="scan'208";a="450677129"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "ms@citd.de" <ms@citd.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mcsim.planeta@gmail.com" <mcsim.planeta@gmail.com>,
        "bernd.schubert@itwm.fraunhofer.de" 
	<bernd.schubert@itwm.fraunhofer.de>,
        "lczerner@redhat.com" <lczerner@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "thomas.knauth@gmx.de" <thomas.knauth@gmx.de>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
Thread-Topic: [PATCH] sysctl: Add a feature to drop caches selectively
Thread-Index: AQHPkeeCpfMUQ+EQuE+W4K3+jm90aQ==
Date: Fri, 27 Jun 2014 09:09:33 +0000
Message-ID: <1403860172.3954.7.camel@sauron.fi.intel.com>
References: <1403626213-7691-1-git-send-email-mcsim.planeta@gmail.com>
	 <alpine.DEB.2.02.1406241458140.29176@chino.kir.corp.google.com>
	 <1403677528.7903.103.camel@sauron.fi.intel.com>
	 <CABhLV03_PNFiwsvt+yitcsKxz5TeVECCFavdNkbgQ+XzQqASaw@mail.gmail.com>
	 <20140626010606.GT4453@dastard>
	 <1403763199.20275.39.camel@sauron.fi.intel.com>
	 <53ABF7C4.1000906@itwm.fraunhofer.de>
	 <1403782263.20275.59.camel@sauron.fi.intel.com>
	 <alpine.LFD.2.00.1406261349320.2172@localhost.localdomain>
	 <20140627084139.GA29704@citd.de>
	 <1403860094.3954.6.camel@sauron.fi.intel.com>
In-Reply-To: <1403860094.3954.6.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.81]
Content-Type: text/plain; charset="utf-8"
Content-ID: <49BEF8476532AD4E85F94D8BA5AC9506@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5R9A9OR023878

On Fri, 2014-06-27 at 12:08 +0300, Artem Bityutskiy wrote:
> To make 100% sure you'd not only need to drop VFS-level caches but also
> file-system-level caches. Indeed, file-systems have their own rather
Sorry, I wanted to say "rather complex" here
> buffers for different indexing data-structures, etc. The unmount/mount
> sequence takes care of that.
> 

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
