Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3HMTWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:22:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3HMTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:22:44 -0400
Message-ID: <520A877F.6050400@wwwdotorg.org>
Date: Tue, 13 Aug 2013 13:22:39 -0600
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
Subject: Re: [PATCH v3] iio: add Bosch BMA180 acceleration sensor driver
References: <1376408677-25892-1-git-send-email-o.v.kravchenko@globallogic.com>
In-Reply-To: <1376408677-25892-1-git-send-email-o.v.kravchenko@globallogic.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 09:44 AM, Oleksandr Kravchenko wrote:
> This patch adds IIO driver for Bosch BMA180 triaxial
> acceleration sensor.
> http://dlnmh9ip6v2uc.cloudfront.net/datasheets/
> 		Sensors/Accelerometers/BST-BMA180-DS000-07_2.pdf

The binding document,
Acked-by: Stephen Warren <swarren@nvidia.com>
