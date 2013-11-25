Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3KYKep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 05:34:45 -0500
Received: from 13.mo1.mail-out.ovh.net ([178.33.253.128]:42933 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752483Ab3KYKen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 05:34:43 -0500
X-Greylist: delayed 5399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Nov 2013 05:34:43 EST
Message-ID: <52930D07.2060805@eukrea.com>
Date: Mon, 25 Nov 2013 09:40:39 +0100
From: Denis Carikli <denis@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: tsc2007 - convert to use devres-managed resources
References: <20131121051438.GA6180@core.coreip.homeip.net>
In-Reply-To: <20131121051438.GA6180@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 939000524253306267
X-Ovh-Remote: 88.170.243.169 (pac33-3-88-170-243-169.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 06:14 AM, Dmitry Torokhov wrote:
> This simplifies error handling path and allows us get rid of
> tsc2007_remove().
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I tested on top of the "tsc2007 misc fixes" and the "tsc2007 - remove 
unused poll_delay from platform data" patches.

Tested-by: Denis Carikli <denis@eukrea.com>

Denis.

