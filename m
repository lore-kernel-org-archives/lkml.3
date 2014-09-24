Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaIXWz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:55:58 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58171 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaIXWz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:55:57 -0400
Message-ID: <54234BF2.6040404@roeck-us.net>
Date: Wed, 24 Sep 2014 15:55:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: atull <atull@opensource.altera.com>, jdelvare@suse.de,
        lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v3 3/3] pmbus: ltc2978: add regulator support
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com> <1411581476-12222-4-git-send-email-atull@opensource.altera.com> <20140924201934.GB25362@roeck-us.net> <alpine.DEB.2.02.1409241536530.9901@atx-linux-37> <20140924211332.GA2720@roeck-us.net> <20140924223322.GL16977@sirena.org.uk>
In-Reply-To: <20140924223322.GL16977@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54234BFC.00FB,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 03:33 PM, Mark Brown wrote:
> On Wed, Sep 24, 2014 at 02:13:32PM -0700, Guenter Roeck wrote:
>> On Wed, Sep 24, 2014 at 03:48:40PM -0500, atull wrote:
>
>>>> regulator.47/name:vout_en0
>
>>> These are just default names, but I think I could make the name better.
>>> How about <part #>-<i2c address>-vout<#> such as "ltc2978-5c-vout0"
>
>> Problem with that is that i2c bus numbers are not static, which would
>> make it quite difficult to describe the regulator in devicetree data.
>
>> Any idea what other regulators do in such situations ?
>
> What's there is correct (modulo the _en), the names are local to the
> chip.  If the user actually cares they will be providing the name of the
> supply on the board anyway.
>

Great, thanks a lot.

Guenter

