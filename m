Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503Ab3HSVYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:24:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33755 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HSVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:24:42 -0400
Message-ID: <52128D10.8070701@wwwdotorg.org>
Date: Mon, 19 Aug 2013 15:24:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleksandr Kravchenko <o.v.kravchenko@globallogic.com>
CC: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ian.campbell@citrix.com, rob@landley.net, jic23@cam.ac.uk,
        denis.ciocca@st.com, srinivas.pandruvada@linux.intel.com,
        lars@metafoo.de
Subject: Re: [PATCH v4 2/2] iio: add Bosch BMA180 acceleration sensor driver
References: <1376655125-13421-1-git-send-email-o.v.kravchenko@globallogic.com> <1376655125-13421-2-git-send-email-o.v.kravchenko@globallogic.com>
In-Reply-To: <1376655125-13421-2-git-send-email-o.v.kravchenko@globallogic.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 06:12 AM, Oleksandr Kravchenko wrote:
> This patch adds IIO driver for Bosch BMA180 triaxial
> acceleration sensor.
> http://dlnmh9ip6v2uc.cloudfront.net/datasheets/
> 		Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf

The binding looks simple enough to me, so the binding,
Acked-by: Stephen Warren <swarren@nvidia.com>

(I'm assuming that the HW is simple enough that this binding fully
describes it and there aren't e.g. GPIOs/regulators/... missing from the
binding).

