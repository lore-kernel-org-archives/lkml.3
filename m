Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3IPSRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:17:06 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42024 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3IPSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:17:04 -0400
Message-ID: <5237593F.5010405@kernel.org>
Date: Mon, 16 Sep 2013 20:17:19 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, arnd@arndb.de,
        linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 14/38] iio: accel: st: Append _accel to accelerator sensor
 device names
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-15-git-send-email-lee.jones@linaro.org> <52345330.4050707@kernel.org> <20130916133106.GI16984@lee--X1> <52370B08.3030709@metafoo.de>
In-Reply-To: <52370B08.3030709@metafoo.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/13 14:43, Lars-Peter Clausen wrote:
> On 09/16/2013 03:31 PM, Lee Jones wrote:
>>> Honestly I don't care either way on these, but consistency would definitely
>>> be good so applied to the togreg branch of iio.git
>>
>> For clarification, is togreg due for the v3.12 merge window or will be
>> get a settling period in -next?
>>
> 
> Well everything up to the 'iio-for-3.12c' tag will be in v3.12, everything
> else not.
> 
> - Lars
> 
Yes.  At the moment IIO is routed through Greg KHs staging tree.  His merge
window closes 1 week before Linus opens the main one (when Greg can figure
out what Linus is intending!)  Hence I close the IIO one whenever I manage
to get a last pull request in before that.

Hence all 3.13 for the current togreg branch.

Jonathan
