Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3A2KGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:06:37 -0500
Received: from multi.imgtec.com ([194.200.65.239]:17601 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab3A2KGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:06:35 -0500
Message-ID: <51079F27.1040905@imgtec.com>
Date: Tue, 29 Jan 2013 10:06:31 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 32/71] ARC: [DeviceTree] Basic support
References: <1359024639-21915-1-git-send-email-vgupta@synopsys.com> <1359024639-21915-15-git-send-email-vgupta@synopsys.com> <5106513E.4010205@imgtec.com> <51079C05.7040308@synopsys.com>
In-Reply-To: <51079C05.7040308@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_29_10_06_33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

>> arm64 also adds dtbs and $(dtb-y) to targets (at least in linux-next). I
>> think this makes sure that they don't get rebuilt unless they've
>> actually changed. I've also copied this for metag.
> 
> Did you verify that it makes a difference - at least at my end it's not - the
> default dtb is getting rebuilt everytime. I need to debug this some more.

Yeh, for me it prevents the following build lines appearing every time:
DTC     arch/metag/boot/dts/tz1090_01sp.dtb

but it still does these every time:
DTB    arch/metag/boot/dts/tz1090_01sp.dtb.S
AS      arch/metag/boot/dts/tz1090_01sp.dtb.o

Adding dtbs o targets actually didn't seem to be necessary with $(dtb-y)
added.

Cheers
James

