Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaLOD36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:29:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55105 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaLOD3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:29:49 -0500
Message-ID: <548E5554.6050900@atmel.com>
Date: Mon, 15 Dec 2014 11:28:20 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        "Alexander Morozov" <linux@meltdown.ru>
Subject: Re: [PATCH 1/3] ASoC: codecs: wm8904: add dt ids table
References: <1418267681-4091-1-git-send-email-voice.shen@atmel.com> <20141212132321.GI11764@sirena.org.uk>
In-Reply-To: <20141212132321.GI11764@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 12/12/2014 09:23 PM, Mark Brown wrote:
> On Thu, Dec 11, 2014 at 11:14:39AM +0800, Bo Shen wrote:
>
>> +static const struct of_device_id wm8904_of_match[] = {
>> +	{ .compatible = "wlf,wm8904", },
>> +	{ .compatible = "wlf,wm8912", },
>> +	{ .compatible = "wlf,wm8918", },
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, wm8904_of_match);
>> +
>>   static struct i2c_driver wm8904_i2c_driver = {
>>   	.driver = {
>>   		.name = "wm8904",
>>   		.owner = THIS_MODULE,
>> +		.of_match_table = wm8904_of_match,
>
> I'm not seeing anything here that ensures that devtype is set correctly
> when probing using the OF IDs - currently we rely on i2c->driver_data.
>

I will add it in v2 patch.
Thanks.

Best Regards,
Bo Shen
