Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3CEFON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:14:13 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16681 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3CEFOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:14:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 04 Mar 2013 21:14:11 -0800
Message-ID: <51357F20.8080008@nvidia.com>
Date: Tue, 5 Mar 2013 14:14:08 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] pwm_bl: Add support for backlight enable GPIO
References: <1362433790-22560-1-git-send-email-achew@nvidia.com> <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de> <51355FA4.1090909@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629BFE1B02@HQMAIL03.nvidia.com> <5135774D.6080708@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629BFE1B11@HQMAIL03.nvidia.com> <51357B9A.8080004@nvidia.com>
In-Reply-To: <51357B9A.8080004@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 01:59 PM, Alex Courbot wrote:
> Btw, you also want to check if the enable-gpio property exists first
> because otherwise probe() will fails if no GPIO is specified).

That's actually not true - I overlooked the fact that probe() checks for 
the GPIO validity before requesting it. My bad.

Alex.


