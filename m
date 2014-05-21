Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbaEUFlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:41:11 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53582 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaEUFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:41:08 -0400
Message-ID: <537C3C6E.6010207@linaro.org>
Date: Wed, 21 May 2014 11:11:02 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org,
        t.figa@samsung.com
Subject: Re: [PATCH] ASoC: samsung: Add 'mclk' handling for Snow sound-card
 driver
References: <1400559942-5666-1-git-send-email-tushar.behera@linaro.org> <20140520111600.GL12304@sirena.org.uk>
In-Reply-To: <20140520111600.GL12304@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/20/2014 04:46 PM, Mark Brown wrote:
> On Tue, May 20, 2014 at 09:55:42AM +0530, Tushar Behera wrote:
>> For audio to work on Snow board, we need the codec master clock
>> 'mclk' to be properly configured.
>> 
>> Currently XCLKOUT is configured as 'mclk' for codec chip and it
>> is required to be clocked at 24MHz for the codec to work
>> properly.
>> 
>> Add appropriate clock handling within Snow sound-card driver to
>> set 'mclk' to operate at 24MHz.
> 
> The clock here is connected to the CODEC on the board so it should
> be connected to the CODEC in the device tree too.
> 

Ok. I will move 'mclk' clock handling to respective CODEC drivers.

- -- 
Tushar Behera
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTfDxtAAoJELqclMPPkq4NkPcH/2fOwVTGgmGFarm2RSoxJcON
QcSQlNpVXEpAqslVdz+ay7VkYCWy+wiuTq4Fe/Yw5RK/Pl7DdkEX/Ltj7/Q6+CbT
38r6o5PSbZLlPcBxVjGXBiOTpK7PZLumF8c1DK4/6HzsHYDzLGTvbWVi6cy9kZzj
X3glD3PBiK/NL12IuOHsRg2wzBRE56RQCmfT2kPueWHEklebGzr/qv5UgdGWa+jb
JRVDt11klGfvIFj+Ov28yave1epzFEzrNm4ixso8MJN7J9HxlufagTheS0HkDpuX
+uY8PbRFTAdT7pjvZR4n2lPws940nk7aUqyVPTQaG9JVKk7R4FVZgBwmhMeIsMU=
=eKSS
-----END PGP SIGNATURE-----
