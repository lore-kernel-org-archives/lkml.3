Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab3HNFzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 01:55:09 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:41515 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3HNFzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 01:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <520A7AE2.9010307@kernel.org>
References: <1376408677-25892-1-git-send-email-o.v.kravchenko@globallogic.com>
	<520A7AE2.9010307@kernel.org>
Date: Wed, 14 Aug 2013 08:55:05 +0300
Message-ID: <CAGH3drq7Pw8g3YJJDVZkRGGqQ_r8qu_X1_-0FTgsZ=MYrUwrcg@mail.gmail.com>
Subject: Re: [PATCH v3] iio: add Bosch BMA180 acceleration sensor driver
From: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        Rob Landley <rob@landley.net>, jic23@cam.ac.uk, denis.ciocca@st.com,
        srinivas.pandruvada@linux.intel.com,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 9:28 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 08/13/13 16:44, Oleksandr Kravchenko wrote:
>> This patch adds IIO driver for Bosch BMA180 triaxial
>> acceleration sensor.
>> http://dlnmh9ip6v2uc.cloudfront.net/datasheets/
>>               Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf
>>
>> Signed-off-by: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
>> ---
> To play the lazy / busy maintainer.  What changed since v2?
>
> This is where that information should be.

In general: fixed problem with possible not unlocked mutex in
bma180_trigger_handler() and moved range, bandwidth and mode
from devtree to sysfs attributes.
