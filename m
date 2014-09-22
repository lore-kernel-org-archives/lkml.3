Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaIVEuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:50:00 -0400
Received: from mail-db3on0124.outbound.protection.outlook.com ([157.55.234.124]:6693
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbaIVEt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:49:59 -0400
Message-ID: <541FAA60.8080506@toradex.com>
Date: Mon, 22 Sep 2014 10:19:36 +0530
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: <shawn.guo@freescale.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ARM: dts: vf610-colibri: Add backlight support
References: <cover.1411130205.git.bhuvanchandra.dv@toradex.com> <bae435d33cac93fd5f0c763fbe7bb302b52a6f0f.1411130205.git.bhuvanchandra.dv@toradex.com> <6548345144e6eb9f252bfa35e9783079@agner.ch>
In-Reply-To: <6548345144e6eb9f252bfa35e9783079@agner.ch>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: BY2PR06CA021.namprd06.prod.outlook.com (10.141.250.139) To
 DB4PR05MB272.eurprd05.prod.outlook.com (10.242.158.27)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB272;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(6049001)(199003)(377424004)(189002)(377454003)(24454002)(52604005)(51704005)(74662003)(76482002)(81542003)(106356001)(4396001)(66066001)(74502003)(46102003)(31966008)(105586002)(86362001)(77096002)(90102001)(47776003)(54356999)(50466002)(80022003)(81342003)(20776003)(64706001)(77982003)(79102003)(21056001)(33656002)(83322001)(19580405001)(107046002)(19580395003)(101416001)(80316001)(65956001)(110136001)(83072002)(36756003)(87266999)(97736003)(76176999)(23746002)(87976001)(85852003)(99396002)(50986999)(83506001)(92726001)(85306004)(95666004)(92566001)(42186005)(120916001)(7059019);DIR:OUT;SFP:1102;SCL:1;SRVR:DB4PR05MB272;H:[10.18.0.136];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: toradex.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 19 September 2014 09:33 PM, Stefan Agner wrote:
> Am 2014-09-19 15:38, schrieb Bhuvanchandra DV:
>> Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
>> ---
>>  arch/arm/boot/dts/vf610-colibri-eval-v3.dts |    6 ++++++
>>  arch/arm/boot/dts/vf610-colibri.dtsi        |    6 ++++++
>>  2 files changed, 12 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> index 00f63d9..711cf82 100644
>> --- a/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> +++ b/arch/arm/boot/dts/vf610-colibri-eval-v3.dts
>> @@ -19,6 +19,12 @@
>>  	};
>>  };
>>  
>> +&bl {
>> +	brightness-levels = <0 4 8 16 32 64 128 255>;
>> +	default-brightness-level = <6>;
>> +	status  = "okay";
>> +};
>> +
>>  &esdhc1 {
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&pinctrl_esdhc1>;
>> diff --git a/arch/arm/boot/dts/vf610-colibri.dtsi
>> b/arch/arm/boot/dts/vf610-colibri.dtsi
>> index 560cd69..20b1c15 100644
>> --- a/arch/arm/boot/dts/vf610-colibri.dtsi
>> +++ b/arch/arm/boot/dts/vf610-colibri.dtsi
>> @@ -13,6 +13,12 @@
>>  	model = "Toradex Colibri VF61 COM";
>>  	compatible = "toradex,vf610-colibri_vf61", "fsl,vf610";
>>  
>> +	bl: backlight {
>> +		compitable = "pwm-backlight";
>> +		pwms = <&pwm0 0 5000000 0>;
>> +		status = "disabled";
>> +	};
>> +
> Typo, "compitable" is not a valid property...
>
> When this is fixed,
> Acked-By: Stefan Agner <stefan@agner.ch>

Thanks for pointing it out. Will update accordingly. 

>>  	clocks {
>>  		enet_ext {
>>  			compatible = "fixed-clock";

