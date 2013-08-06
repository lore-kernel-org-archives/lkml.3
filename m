Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab3HFNKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:10:02 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.175]:33542 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593Ab3HFNKA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 09:10:00 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-13.tower-39.messagelabs.com!1375794597!5008662!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: Steve Twiss <stwiss.opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V1] DA9210 driver files
Thread-Topic: [PATCH V1] DA9210 driver files
Thread-Index: AQHOgXxrWx5i10fWtkCsxWQwz+nts5mIR0KQ
Date: Tue, 6 Aug 2013 13:09:56 +0000
Message-ID: <6ED8E3B22081A4459DAC7699F3695FB71D723213@SW-EX-MBX02.diasemi.com>
References: <201307151518.r6FFIve6031479@swsrvapps-01.diasemi.com>
 <20130715165735.GU11538@sirena.org.uk>
In-Reply-To: <20130715165735.GU11538@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15 July 2013 17:58 Mark Brown wrote:

>Subject: Re: [PATCH V1] DA9210 driver files

I should have named this PATCH V3 to follow on from previous versions
from RFC that I submitted. 

>To repeat *again* you should submit patches in the format covered in
>SubmittingPatches.  This includes things like the commit message, if
>your commit message doesn't look like other commit messages for the code
>you're changing that's an issue.

Apologies again.
I will try to make this identical to those provided in other commit 
messages ...

>
>> +struct da9210 {
>> +	struct device *dev;
>
>This is never used as far as I can tell.
>

Not used.. removed.

>> +MODULE_ALIAS("platform: da9210");
>
>This is for a platform device but this is an I2C device so would never
>match.  Also for a platform device the string should have no space in
>it.
>

Done this.
I will re-submit this asap.

>Otherwise this looks OK, though it'd be better to fill in the register
>map information more (listing the valid registers for example).

Thank you,
Steve
