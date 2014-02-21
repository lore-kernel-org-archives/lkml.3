Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaBUBoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:44:16 -0500
Received: from mx2.parallels.com ([199.115.105.18]:50340 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaBUBoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:44:14 -0500
From: James Bottomley <jbottomley@parallels.com>
To: "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "ching2048@areca.com.tw" <ching2048@areca.com.tw>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "billion.wu@areca.com.tw" <billion.wu@areca.com.tw>
Subject: Re: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Thread-Topic: [PATCH v1.3 1/11] arcmsr: Revise interrupt service routine to
 fix command timeout
Thread-Index: AQHPLjQAtT3ll7+PRE2ub6/putTVXZq+lFaAgADiDwA=
Date: Fri, 21 Feb 2014 01:43:40 +0000
Message-ID: <1392947020.11425.1.camel@dabdike>
References: <CAKiknE9pf-hQOTcxbw8WnHECDJDZMHJA-TBEPeg7+q5nb+AoCA@mail.gmail.com>
	 <20140220121435.GY26776@mwanda>
In-Reply-To: <20140220121435.GY26776@mwanda>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.187.233.203]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F9384BD96208894E9206BE2B54A5C0D1@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1L1iL9b025865

On Thu, 2014-02-20 at 15:14 +0300, Dan Carpenter wrote:
> On Thu, Feb 20, 2014 at 08:05:05PM +0800, é»ƒæ¸…éš† wrote:
> > From: Ching <ching2048@areca.com.tw>
> > 
> > Rewrite interrupt service routine to fix command timeout on controller too
> > heavy loading.
> > 
> > Singed-off-by: Ching <ching2048@areca.com.tw>
> 
> Your email client screwed up the whitespace completely.  Read
> Documentation/email-clients.txt or use `git send-email`
> http://www.freedesktop.org/wiki/Software/PulseAudio/HowToUseGitSendEmail/
> 
> There are also many unrelated white space changes in this patch.

Actually, none of these patches even made it to the SCSI list, because
they had html parts, which vger destroys.  Please make the changes Dan
suggests and then resubmit as plain text only.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
