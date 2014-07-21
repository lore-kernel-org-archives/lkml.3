Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaGUNXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:23:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47639 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaGUNXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:23:23 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: "linux-sound@vger.kernel.org" <linux-sound@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 1/2] ASoC: tas2552: Fix PM sequencing
Thread-Topic: [PATCH 1/2] ASoC: tas2552: Fix PM sequencing
Thread-Index: AQHPoq4QUYTcCVBKP026fhdJSNRj2A==
Date: Mon, 21 Jul 2014 13:23:17 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49D88593@DFLE09.ent.ti.com>
References: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
 <20140721121931.GX17528@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark

On 07/21/2014 07:19 AM, Mark Brown wrote:
> On Fri, Jul 18, 2014 at 12:31:07PM -0500, Dan Murphy wrote:
>> In the pm suspend/resume it is better
>> to disable the GPIO after the regmap_cache
>> setting calls so that if the call is interrupted
>> the new reg values will be cached and set on resume.
>>
>> Also add pm_runtime_put in the remove call.
> Applied, thanks, but please don't mix multiple changes into one commit
> like this especially when there's no textual overlap.

I usually don't mix changes like this as I like to have a single change per
commit.

But I find each maintainer is a little different but now I know for next time.

Thanks

-- 
------------------
Dan Murphy

