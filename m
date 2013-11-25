Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3KYJEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:04:50 -0500
Received: from 4.mo1.mail-out.ovh.net ([46.105.76.26]:50096 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754201Ab3KYJEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:04:44 -0500
Message-ID: <52930D03.2070607@eukrea.com>
Date: Mon, 25 Nov 2013 09:40:35 +0100
From: Denis Carikli <denis@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: tsc2007 - remove unused poll_delay from platform
 data
References: <20131121051319.GA6131@core.coreip.homeip.net>
In-Reply-To: <20131121051319.GA6131@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 937874624332307867
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

On 11/21/2013 06:13 AM, Dmitry Torokhov wrote:
> The driver does not use poll_delay parameter, so let's remove it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I tested on top of the "tsc2007 misc fixes" patch.

Tested-by: Denis Carikli <denis@eukrea.com>

Denis.
