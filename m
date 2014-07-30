Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaG3I4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:56:08 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58837 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaG3I4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:56:05 -0400
Message-ID: <53D8B31F.6040404@collabora.co.uk>
Date: Wed, 30 Jul 2014 10:55:59 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/5] regulator: tps65090: Set voltage for fixed regulators
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk> <1406651339-28901-5-git-send-email-javier.martinez@collabora.co.uk> <20140729173631.GX17528@sirena.org.uk>
In-Reply-To: <20140729173631.GX17528@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 07:36 PM, Mark Brown wrote:
> On Tue, Jul 29, 2014 at 06:28:58PM +0200, Javier Martinez Canillas wrote:
> 
>> +#define tps65090_REG_VAR(_id, _sname, en_reg, _en_bits, _ops) \
>> +	tps65090_REG_DESC(_id, _sname, en_reg, _en_bits, 0, 0, _ops)
> 
> I'd expect this to describe a variable regulator when in fact it
> seems it describes a switch with no regulation.  Better name please.
> 

Yes, when writing the patch I thought of a switch as a non-fixed regulator whose
output voltage is variable and depend on its input supply voltage. That's why I
used VAR but I agree that is a bad name and I'll change it.

Thanks a lot and best regards,
Javier
