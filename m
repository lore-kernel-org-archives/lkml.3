Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab3GGIrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 04:47:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:55488 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3GGIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 04:47:21 -0400
Message-ID: <51D92B19.8000706@free-electrons.com>
Date: Sun, 07 Jul 2013 10:47:21 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Jonathan Cameron <jic23@cam.ac.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Rob Landley <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCHv3 2/3] ARM: mxs: cfa10049: Switch bus i2c1 to bitbanging
References: <1372094699-3832-1-git-send-email-alexandre.belloni@free-electrons.com> <1372094699-3832-3-git-send-email-alexandre.belloni@free-electrons.com> <51D7F0E6.2000008@kernel.org>
In-Reply-To: <51D7F0E6.2000008@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 12:26, Jonathan Cameron wrote:
> On 06/24/2013 06:24 PM, Alexandre Belloni wrote:
>> From: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> The ADCs connected to this bus have been experiencing some timeout
>> issues when using the iMX28 i2c controller. Switching back to bitbanging
>> solves this.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> As there are no disadvantages in taking the driver through IIO and these changes
> through the appropriate arch trees, I'd not propose to take these through IIO
> (even when the discussion is done) unless specifically asked to.
> 

Sure, especially since, we may finally not move to i2c bitbanging. I'll
probably resend a new version of those patches separately.

Shawn, please wait for the i2c-mxs PIO/DMA mode discussion to end before
applying. If possible, I would prefer not using bitbanging.

Regards,


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
