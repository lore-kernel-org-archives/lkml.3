Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3D2MRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:17:46 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:46942 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab3D2MRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:17:44 -0400
Message-ID: <517E64A1.4020402@streamunlimited.com>
Date: Mon, 29 Apr 2013 14:16:33 +0200
From: Marek Belisko <marek.belisko@streamunlimited.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Marek Belisko <marek.belisko@gmail.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, alsa-devel@alsa-project.org,
        linux-doc@vger.kernel.org, tiwai@suse.de,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, perex@perex.cz
Subject: Re: [PATCH v2 2/3] ASoC: spdif_transmitter: Add DT support.
References: <1366895594-19596-1-git-send-email-marek.belisko@streamunlimited.com> <1366895594-19596-3-git-send-email-marek.belisko@streamunlimited.com> <517AD46A.2020402@gmail.com>
In-Reply-To: <517AD46A.2020402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: marek.belisko@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sebastian Hesselbarth,

On 04/26/2013 09:24 PM, Sebastian Hesselbarth wrote:
> On 04/25/2013 03:13 PM, Marek Belisko wrote:
>> Add devicetree support for this dummy audio soc driver.
>>
>> Signed-off-by: Michal Bachraty<michal.bachraty@streamunlimited.com>
>> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>
>> ---
>>   .../bindings/sound/spdif-transmitter.txt           |   10 ++++++++++
>>   sound/soc/codecs/spdif_transmitter.c               |   10 ++++++++++
>>   2 files changed, 20 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/sound/spdif-transmitter.txt
>>
>> diff --git
>> a/Documentation/devicetree/bindings/sound/spdif-transmitter.txt
>> b/Documentation/devicetree/bindings/sound/spdif-transmitter.txt
>> new file mode 100644
>> index 0000000..55a8584
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/sound/spdif-transmitter.txt
>> @@ -0,0 +1,10 @@
>> +Device-Tree bindings for dummy spdif transmitter
>> +
>> +Required properties:
>> +    - compatible: should be "linux,spdif-dit".
>
> Marek,
>
> I remember Daniel commenting on the name already, but
> what about "spdif-transmitter" and "spdif-receiver" respectively?
Agree.
> That is very generic and should allow to remove "linux," prefix.
Not sure if linux, prefix can be removed. I believe (at least what 
documentation said) is that <manufacturer>,<model> must be format for 
compatible.
> And there is a lot of drivers using more informative compatible
> strings compared to the driver name.
>
> Sebastian
>

Cheers,

	~marek
-- 
Marek Belisko

Software Developer
StreamUnlimited Engineering GmbH
Gutheil Schodergasse 8-12
A-1100 Vienna, Austria

Office: +421 267200087

e-mail: marek.belisko@streamunlimited.com
http://www.streamunlimited.com

Meet us at:

High End - Munich, 09 - 12 May, Hall 4/F05
IFA - Berlin, 6-11 September
CEDIA - Denver, 25-28 September
