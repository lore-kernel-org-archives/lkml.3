Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974Ab3APWn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 17:43:56 -0500
Received: from mail.grid-net.com ([97.65.115.18]:24838 "EHLO mail.grid-net.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757553Ab3APWnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 17:43:55 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jan 2013 17:43:55 EST
From: Subodh Nijsure <snijsure@grid-net.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        "penguin-kernel@I-love.SAKURA.ne.jp" 
	<penguin-kernel@I-love.SAKURA.ne.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: RE: [v4] Add security.* XATTR support for the UBIFS
Thread-Topic: [v4] Add security.* XATTR support for the UBIFS
Thread-Index: AQHN8ze5utowllyuKESuvYU4uc18WphNBjyA//+G8Vg=
Date: Wed, 16 Jan 2013 22:38:31 +0000
Message-ID: <B437D8FD67C39240BFA9DD878702A627102E7E16@mx2.grid-net.com>
References: <1336915488-23943-1-git-send-email-snijsure@grid-net.com>
 <50F57A30.10109@pengutronix.de>,<50F72047.6000904@pengutronix.de>
In-Reply-To: <50F72047.6000904@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.103.45.7]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Marc,

On 01/15/2013 04:48 PM, Marc Kleine-Budde wrote:
> On 05/13/2012 05:24 AM, Subodh Nijsure wrote:
>> From: Subodh Nijsure <snijsure@grid-net.com>
>>
>> Also fix couple of bugs in UBIFS extended attribute length calculation.
>>
>> Changes in v4:
>>         Fix lock issues introduced in v3.
>>         Tested with CONFIG_SECURITY enabled & disabled.
>>
>> Changes in v3:
>>       Remove #ifdef CONFIG_UBIFS_FS_XATTR
>>
>> Changes in v2:
>>          Instead of just handling security.selinux extended attribute handle
>>          all security.* attributes.
>>
>> TESTING: Tested on  MX28 based platforms using Micron MT29F2G08ABAEAH4 NAND
>>          With these change we are able to label UBIFS filesystem with
>>          security.selinux and run system with selinux enabled.
>>          This change also allows one to set other security.* extended
>>          attributes, such as security.smack security.evm, security.ima
>>          Ran integck test on UBI filesystem.
>>          This patch set has been tested with CONFIG_LOCKDEP=y and other options
>>          suggested in Submitchecklist
>>
>> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
>
> What's the status of this patch? Was there a v5?


>I've ported v4 to v3.7.2 and get this deadlock:

Sorry I didn't try to push it and now I am on family leave to take care of new baby at home till end of March. 
I don't have access to hardware any more to try this at home, so I would certainly get to it till beginning of April.

-Subodh