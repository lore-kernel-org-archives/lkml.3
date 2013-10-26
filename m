Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3JZDAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 23:00:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65289 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3JZDAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 23:00:51 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-e0-526b3061ad28
Message-id: <526B3063.30600@samsung.com>
Date: Sat, 26 Oct 2013 12:00:51 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Grant Likely <grant.likely@linaro.org>
Cc: anton@enomsg.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dwmw2@infradead.org, rob.herring@calxeda.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH 3/4] charger-manager: Add device tree binding for
 charger-manager
References: <1382446317-32613-1-git-send-email-cw00.choi@samsung.com>
 <1382446317-32613-4-git-send-email-cw00.choi@samsung.com>
 <20131025200344.85AA5C40566@trevor.secretlab.ca>
In-reply-to: <20131025200344.85AA5C40566@trevor.secretlab.ca>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkQDfRIDvI4MFUWYuDWzUt5h85x2ox
	ceVkZosDf3YwWpxtesNucXnXHDaL240r2CwOrzjA5MDhseDzFXaPCf2fGD02r9DyuHNtD5tH
	35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZbxe2MJYsEO54vTn50wNjEtkuxg5OSQETCS2d81j
	hbDFJC7cW8/WxcjFISSwlFHi5swfzDBFc45PZYRITGeUeD7rHVTVK0aJxW82s4NU8QpoSCy+
	cRdsFIuAqsT9f+1sIDabgJbE/hc3wGxRgTCJldOvsEDUC0r8mHwPzBYBqnky5zPYUGaBrYwS
	E37dZQJJCAuESxw+v5AVYtsWRokbE7YC3cTBwSlgK7H0bzxIDbOAjsT+1mlsELa8xOY1b5lB
	6iUE7rFLbJ5wgQ3iIgGJb5MPsYD0SgjISmw6APWapMTBFTdYJjCKzUJy0ywkY2chGbuAkXkV
	o2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmAsnv73bMIOxnsHrA8xJgOtnMgsJZqcD4zlvJJ4
	Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgNHx8z9em
	bk1GqtbJ9nX5z/JeH5m+Qqb2pFO2Hv+HFK2/TW9Ws1nf+HNr13KDA7dvdmrr9Ft6LnrJOjfT
	fm/hnL17di5a11Bc/ebVQo7PwbLewsXJqUt4Jmt/3OZVEfN5Sdyj0lTGJWmHrrwIv6MYGef3
	5P+3/ftVeNXYepbLHtEXOxUctz7othJLcUaioRZzUXEiAHg0SwPbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQd1Eg+wgg84pIhYHt2pazD9yjtVi
	4srJzBYH/uxgtDjb9Ibd4vKuOWwWtxtXsFkcXnGAyYHDY8HnK+weE/o/MXpsXqHlcefaHjaP
	vi2rGD0+b5ILYItqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxemELY8EO
	5YrTn58zNTAuke1i5OSQEDCRmHN8KiOELSZx4d56ti5GLg4hgemMEs9nvYNyXjFKLH6zmR2k
	ildAQ2LxjbusIDaLgKrE/X/tbCA2m4CWxP4XN8BsUYEwiZXTr7BA1AtK/Jh8D8wWAap5Mucz
	2FBmga2MEhN+3WUCSQgLhEscPr+QFWLbFkaJGxO2MncxcnBwCthKLP0bD1LDLKAjsb91GhuE
	LS+xec1b5gmMArOQ7JiFpGwWkrIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYIj/ZnU
	DsaVDRaHGAU4GJV4eAvas4KEWBPLiitzDzFKcDArifCu/gEU4k1JrKxKLcqPLyrNSS0+xJgM
	DIKJzFKiyfnAJJRXEm9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYxM9YfbvpvxsBy9KBtiYbewZ0JZfLHd0v5Ph1sKD9g/iTr2NWDK9Vc/vRhFWF7veKCqfq9r
	2UqBtw5M1033BbpIqXzxcBc+L/NSYNekLZdZ56fsC5wQ9V75nMMflVdW/gdXzuUQXb1NU3hq
	kYPAhB5fw5A9dq7zNQuW8opkuYq6z+rOc9F4vUaJpTgj0VCLuag4EQB4+Oz7OAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 10/26/2013 05:03 AM, Grant Likely wrote:
> On Tue, 22 Oct 2013 21:51:56 +0900, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch add binding file for charger-manager that this framework enables to
>> control and multiple chargers and to monitor charging event.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>> ---
>>  .../devicetree/bindings/power/charger-manager.txt  | 106 +++++++++++++++++++++
>>  1 file changed, 106 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/power/charger-manager.txt
>>
>> diff --git a/Documentation/devicetree/bindings/power/charger-manager.txt b/Documentation/devicetree/bindings/power/charger-manager.txt
>> new file mode 100644
>> index 0000000..b22c5526
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/power/charger-manager.txt
>> @@ -0,0 +1,106 @@
>> +Charger-manager framework
>> +
>> +THe devicetree bindings are for the charger-manager to control charging feature.
>> +
>> +This framework enables to control and multiple chargers and to monitor charging
>> +event in the context of suspend-to-RAM with an interface combining the chargers.
>> +
>> +Required Properties:
>> +- compatible:		Must be "charger-manager".
>> +- psy-name:		The name of power-supply class for charger-manager.
>> +- polling-mode:		Determine which polling mode will be used.
>> +- polling-invertal-ms:	Interval in millisecond at which charger-manager will
>> +			monitor battery health.
>> +- fullbatt-vchkdrop-ms
>> +- fullbatt-vchkdrop-uV:	Check voltage drop afer the battery is fully charged.
>> +			If it has dropped more than fullbatt_vchkdrop_uV after
>> +			fullbatt_vchkdrop_ms, charger-manager will restart
>> +			charging.
>> +- fullbatt-uV:		The standard voltage in microvolt for checking
>> +			fully charged. If VBATT >= fullbatt_uV, it is assumed to
>> +			be full.
>> +- fullbatt-soc:		The standard SOC(State Of Charger) for checking
>> +			fully charged. If state of Charge >= fullbatt_soc, it is
>> +			assumed to be full.
>> +- fullbatt-full-capacity: The standard capacity for checking fully charged.
>> +			If full capacity of battery >= fullbatt_full_capacity,
>> +			it is assumed to be full.
>> +- battery-present:	Specify where information for existance of battery
>> +			can be obtained.
>> +- measure-battery-temp:	Whether to measure battery or not
>> +
>> +- charging-max-duration-minute:		Maximum possible duration for charging.
>> +			If whole charging duration exceed 'charging-max-duration
>> +			-ms', charger-manager stop charging.
>> +- discharging-max-duration-minute:	Maximum possible duration for
>> +			discharging with charger cable after full-batt. If
>> +			discharging duration exceed 'discharging-max-duration-
>> +			ms', charger-manager start charging.
>> +- psy-fuelgauge-name:	The name of power-supply for fuel gauge
>> +- io-channels:		The iio channel data for ADC
>> +- iio-adc-overheat:	The value of the highest ADC for temperature
>> +- iio-adc-cold:		The value of the lowest ADC for temperature
>> +- psy-chargers:		Arrary of power-supply name for chargers.
>> +- charger-regulators:	Array of charger regulators. It include charger cable
>> +			data which need cable-name/extcon-name/min-current-uA
>> +			max-current-uA. When cable is attached/detached,
>> +			charger-manager change current limit of regulator
>> +			according to min-current-uA/max-current-uA.
> 
> The documentation for the above properties needs to specify what the
> values actually mean. For example, "polling-mode" is documented as
> "Determine which polling mode will be used". Huh? What is the difference
> between a value of 0 or 1? What values are valid? What do they mean?
> 
> As it stands I suspect that the binding is a direct translation from the
> existing pdata structure. That probably isn't really what you want. Some
> of the properties above do make sense and are documented correctly (ie.
> fullbatt-*), but others don't make sense and probably shouldn't be part
> of the generic binding (ie. io-channels sounds like something device
> specific).
> 
> I'll defer to the regulators people on what does and does not make
> sense.
> 

OK, I add detailed and easy description for improving the understanding
in accordance with your comment and will resend this patchset.

Thanks.

Best Regards,
Chanwoo Choi
