Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab3ATGkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 01:40:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:25302 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab3ATGkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 01:40:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,500,1355126400"; 
   d="scan'208";a="246091307"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
        Hugh Dickins <hughd@google.com>
CC: "Berg, Johannes" <johannes.berg@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: iwlwifi: regression in 3.8-rc4 and 3.7.3
Thread-Topic: iwlwifi: regression in 3.8-rc4 and 3.7.3
Thread-Index: AQHN9tMJYFNVPi7MAk6HUtQZ9hE5lZhRm0CAgAAmukA=
Date: Sun, 20 Jan 2013 06:39:30 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301920DA0@HASMSX103.ger.corp.intel.com>
References: <alpine.LNX.2.00.1301192141540.1303@eggly.anvils>
 <CA+icZUWULf9-3vEQHM59HM7+PPXxvpWGnNB137+=WyEXj9noiQ@mail.gmail.com>
In-Reply-To: <CA+icZUWULf9-3vEQHM59HM7+PPXxvpWGnNB137+=WyEXj9noiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0K6f9pG013991

> 
> On Sun, Jan 20, 2013 at 6:56 AM, Hugh Dickins <hughd@google.com> wrote:
> > After sending the first 2MB, scp over wireless becomes unbearably
> > slow, with frequent stalls: on this ThinkPad T420s running 3.8-rc4 or 3.7.3.
> > Not always, but often.
> >
> 
> There is one pending iwlwifi-fixes, dunno if it will fix your issue.
> [1] http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-
> fixes.git;a=commitdiff;h=c3e5d7181afb66657393066bccce0956fab09ab3

Right - so the 2 patches are unrelated, and the one Sedat is pointing at is relevant for 3.8 only. It fixes a bug that has been introduced in 3.8.
Regarding the issue Hugh is suffering from, I have to say that I am a little confused since I am pretty sure the patch is right. Now, it might uncover other pre-existing bugs. All I can say is that I don't think that reverting the patch is *so* problematic since the patch really wants to solve a rare case. If it causes issues, we can simply revert it. It only means that when I will get a little bit of time, I might need to ask you a few logs. Thanks for the report (and the bisection).
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
