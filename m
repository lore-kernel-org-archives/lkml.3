Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaHMXeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:34:23 -0400
Received: from 99-65-72-228.uvs.sntcca.sbcglobal.net ([99.65.72.228]:20639
	"EHLO stargate.chelsio.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752001AbaHMXeV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:34:21 -0400
From: Anish Bhatt <anish@chelsio.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Casey Leedom <leedom@chelsio.com>
CC: "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        "Pierre Fersing" <pierre-fersing@pierref.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Benjamin Poirier" <bpoirier@suse.de>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        Hariprasad S <hariprasad@chelsio.com>,
        Santosh Rastapur <santosh@chelsio.com>,
        "MPT-FusionLinux.pdl@avagotech.com" 
	<MPT-FusionLinux.pdl@avagotech.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] cxgb4: use module_long_probe_init()
Thread-Topic: [PATCH v3 2/3] cxgb4: use module_long_probe_init()
Thread-Index: AQHPtn0CiAUcSVeYx0aX21+93w4FGZvPMJ0D
Date: Wed, 13 Aug 2014 23:33:32 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D85A0977@nice.asicdesigners.com>
References: <1407882507-325-1-git-send-email-mcgrof@do-not-panic.com>,<1407882507-325-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1407882507-325-3-git-send-email-mcgrof@do-not-panic.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.164.225]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Casey who's actually incharge of this code and missing from the CC list
-Anish
