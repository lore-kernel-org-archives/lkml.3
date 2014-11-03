Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaKCA1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:27:33 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:35103 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbaKCA1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:27:32 -0500
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 1
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: javier.martinez@collabora.co.uk
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <0050ce91b0ae7b7ea35f78f86c4b6428>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5456CBE5.9050209@rock-chips.com>
Date: Mon, 03 Nov 2014 08:27:17 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>
CC: Heiko Stuebner <heiko@sntech.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        carlos@github.map.fastly.net, rdunlap@infradead.org, jkosina@suse.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: Document binding for regulator suspend
 voltage
References: <1414813978-32233-1-git-send-email-dianders@chromium.org> <54549DBA.5020102@collabora.co.uk>
In-Reply-To: <54549DBA.5020102@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/01/2014 04:45 PM, Javier Martinez Canillas wrote:
> Hello Doug,
>
> On 11/01/2014 04:52 AM, Doug Anderson wrote:
>> This patch builds upon (291d761 regulator: Document binding for
>> regulator suspend state for PM state) to allow setting the uV in
>> addition to the state at suspend time.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>   Documentation/devicetree/bindings/regulator/regulator.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
>> index aaad615..4e7ed76 100644
>> --- a/Documentation/devicetree/bindings/regulator/regulator.txt
>> +++ b/Documentation/devicetree/bindings/regulator/regulator.txt
>> @@ -28,6 +28,8 @@ Optional properties:
>>   - regulator-state-[mem/disk] node has following common properties:
>>   	- regulator-on-in-suspend: regulator should be on in suspend state.
>>   	- regulator-off-in-suspend: regulator should be off in suspend state.
>> +	- regulator-suspend-microvolt: regulator should be set to this voltage
>> +	  in suspend.
> The patch looks good to me:
>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>
> On thing I wonder is if the binding should say that the suspend voltage is
> independent of the runtime one and it may be outside of the runtime range?
>
> Best regards,
> Javier
>
>
>

Reviewed-by: Chris Zhong <zyw@rock-chips.com>


