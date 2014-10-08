Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaJHQB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:01:56 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52618 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:01:54 -0400
Message-ID: <54355FEA.3030301@collabora.co.uk>
Date: Wed, 08 Oct 2014 18:01:46 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/5] regulator: max77802: Add regulator operating mode
 set support
References: <1412775847-15213-1-git-send-email-javier.martinez@collabora.co.uk> <1412775847-15213-5-git-send-email-javier.martinez@collabora.co.uk> <20141008143632.GC4609@sirena.org.uk>
In-Reply-To: <20141008143632.GC4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 04:36 PM, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 03:44:06PM +0200, Javier Martinez Canillas wrote:
>> Add a function handler for the struct regulator_ops .set_mode so an
>> operating mode (opmode) can be set for regulators.
>> 
>> Regulators opmode are defined using the generic REGULATOR_MODE_*
>> modes so the driver maps these generic modes to the device-specific
>> operating modes as stated in the hardware data-sheet.
> 
> Why is this implementing a set operation but not a get operation?
> 

Right, I'll add it on the next version. Thanks for pointing out this.

Best regards,
Javier
