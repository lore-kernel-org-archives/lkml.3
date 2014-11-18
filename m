Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaKRIlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:41:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31549 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaKRIlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:41:18 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-91-546b062b713e
Message-id: <546B062B.3060406@samsung.com>
Date: Tue, 18 Nov 2014 17:41:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] regulator: s2mps11: Add support S2MPS13 regulator
 device
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
 <20141118081757.GS24004@x1>
In-reply-to: <20141118081757.GS24004@x1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWyRsSkUFebLTvE4McBC4slF6+yW0x9+ITN
	Yv6Rc6wWfya0sllMuj+BxeJs0xt2i/tfjzJafLvSwWRxedccNounEy6yWZzuZrW4uOILkwOP
	x85Zd9k9Nq3qZPO4c20Pm8e8k4EefVtWMXpMn/eTyePzJrkA9igum5TUnMyy1CJ9uwSujBk9
	/gV/OSqafjayNDA2sncxcnJICJhI3PzTzQphi0lcuLeerYuRi0NIYCmjxOw9bcwwRW3PVkMl
	FjFKbLy/jR3Cec0osXBpNxtIFa+AlkTzrJlgY1kEVCXu/DvMBGKzAcX3v7gBViMqECaxcvoV
	Foh6QYkfk+8B2RwcIgIqEufemIPMZBboY5L43fMAbI6wQLDEvgNzoDbPZpR48GwDWDOngIbE
	ggk7GUFsZgF1iUnzFjFD2PISm9e8hTr7J7vExjmCEAcJSHybfAhsmYSArMSmA1AlkhIHV9xg
	mcAoNgvJSbOQTJ2FZOoCRuZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIGRe/rfswk7GO8d
	sD7EKMDBqMTDmzg1K0SINbGsuDL3EKMp0BUTmaVEk/OB6SGvJN7Q2MzIwtTE1NjI3NJMSZz3
	tdTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MHd/1XiyMZn1557fX9kyF7i85OrrbutIL
	ecw8+16d+b771C91sc/rPjB6Vb96bhmt+5L12Vb2q+wFjG8Xy6kc+Wrd4Joh76d1vJ/veGro
	n5zDuXHthuKM1X2XmPxVFiTzeEjoNjZMPvdc5UFk4zerNG/pKTlHlBal5R40WyhZ/TVY3btH
	vVuJpTgj0VCLuag4EQD+CMTW1wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgK42W3aIQW+7gcWSi1fZLaY+fMJm
	Mf/IOVaLPxNa2Swm3Z/AYnG26Q27xf2vRxktvl3pYLK4vGsOm8XTCRfZLE53s1pcXPGFyYHH
	Y+esu+wem1Z1snncubaHzWPeyUCPvi2rGD2mz/vJ5PF5k1wAe1QDo01GamJKapFCal5yfkpm
	XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0KFKCmWJOaVAoYDE4mIlfTtME0JD
	3HQtYBojdH1DguB6jAzQQMIaxowZPf4Ffzkqmn42sjQwNrJ3MXJySAiYSLQ9W80GYYtJXLi3
	Hsjm4hASWMQosfH+NnYI5zWjxMKl3WBVvAJaEs2zZoJ1swioStz5d5gJxGYDiu9/cQOsRlQg
	TGLl9CssEPWCEj8m3wOyOThEBFQkzr0xB5nJLNDHJPG75wHYHGGBYIl9B+ZAbZ7NKPHg2Qaw
	Zk4BDYkFE3YygtjMAuoSk+YtYoaw5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnBieCa9g3FVg8UhRgEORiUe3sSpWSFCrIllxZW5hxglOJiVRHjP
	dQOFeFMSK6tSi/Lji0pzUosPMZoCg2Ais5Rocj4waeWVxBsam5gZWRqZG1oYGZsrifMebLUO
	FBJITyxJzU5NLUgtgulj4uCUamBsS+wsY9O7tXBh34rwF/83TTs6Scy52+fv/0XsNyc1m3N2
	hrX/KJgdbBetfy4ttmqOsevXw0wuUtzHLHwvvJZxWRC3oN06Uu2UhZOIyZ1VNyz35CwLb8nq
	+R5vPfmmyJUlexSD1KaG9160EOL5mfw79+XTcM2TzbleVeFZ/AlHYorKhYX271diKc5INNRi
	LipOBADQY9g+IgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lee,

On 11/18/2014 05:17 PM, Lee Jones wrote:
> On Mon, 17 Nov 2014, Chanwoo Choi wrote:
> 
>> This patch adds S2MPS13 regulator device to existing S2MPS11 device driver.
>> The S2MPS13 has just different number of regulators from S2MPS14.
>> The S2MPS13 regulator device includes LDO[1-40] and BUCK[1-10].
>>
>> Cc: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/mfd/sec-core.c              |  13 +++
>>  drivers/regulator/Kconfig           |  10 +-
>>  drivers/regulator/s2mps11.c         | 102 +++++++++++++++++++-
>>  include/linux/mfd/samsung/core.h    |   1 +
>>  include/linux/mfd/samsung/s2mps13.h | 186 ++++++++++++++++++++++++++++++++++++
> 
> For my reference:
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> I does this set need to go in all at once, or can it be broken up?

If possible, I think that this patchset would be better to apply it on same git-repo at once.

Best Regards,
Chanwoo Choi

> 
>>  5 files changed, 304 insertions(+), 8 deletions(-)
>>  create mode 100644 include/linux/mfd/samsung/s2mps13.h
> 
> [...]
> 

