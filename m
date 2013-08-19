Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3HSVWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:22:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41351 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HSVWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:22:33 -0400
Message-ID: <52128C94.2070402@wwwdotorg.org>
Date: Mon, 19 Aug 2013 15:22:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob@landley.net, jic23@cam.ac.uk,
        denis.ciocca@st.com, srinivas.pandruvada@linux.intel.com,
        lars@metafoo.de
Subject: Re: [PATCH v4 2/2] iio: add Bosch BMA180 acceleration sensor driver
References: <1376655125-13421-1-git-send-email-o.v.kravchenko@globallogic.com> <1376655125-13421-2-git-send-email-o.v.kravchenko@globallogic.com> <520FDF09.2000507@kernel.org>
In-Reply-To: <520FDF09.2000507@kernel.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2013 02:37 PM, Jonathan Cameron wrote:
> On 08/16/13 13:12, Oleksandr Kravchenko wrote:
>> This patch adds IIO driver for Bosch BMA180 triaxial
>> acceleration sensor.
>> http://dlnmh9ip6v2uc.cloudfront.net/datasheets/
>> 		Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf
>>
>> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
> 
> Surely your power_mode ext_info entry wants to be shared?
> It is the same control for all 3 accelerometer channels...
> 
> Jonathan

Admittedly you put a signature here so it was a little bit clearer than
some cases, but it'd help greatly if all irrelevant context was deleted
from emails when replying so people reading the reply didn't have to
scroll through hundreds of lines of patch just to see if anything else
was said.

> [entire original patch quoted]
