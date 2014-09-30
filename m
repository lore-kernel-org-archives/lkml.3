Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaI3UUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:20:09 -0400
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:11541
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750883AbaI3UUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:20:06 -0400
X-Greylist: delayed 74583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Sep 2014 16:20:06 EDT
From: Jojy Varghese <jojyv@juniper.net>
To: Scott Wood <scottwood@freescale.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>,
        "hongtao.jia@freescale.com" <hongtao.jia@freescale.com>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Topic: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Index: AQHP3AU6xL0ppKreQk6rqjZx79AU1JwYcGsAgAAIjYD//8zWgIAAfQkAgAERo4D//9SpAIAAddaA//+LdoA=
Date: Tue, 30 Sep 2014 20:20:03 +0000
Message-ID: <D0505E5A.10E46%jojyv@juniper.net>
In-Reply-To: <1412108227.13320.309.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [66.129.239.13]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR05MB527;
x-forefront-prvs: 0350D7A55D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(199003)(479174003)(377454003)(189002)(377424004)(92566001)(110136001)(2656002)(87936001)(4396001)(85852003)(80022003)(86362001)(10300001)(76482002)(46102003)(101416001)(92726001)(99396003)(19580405001)(120916001)(106116001)(105586002)(20776003)(95666004)(99286002)(85306004)(31966008)(21056001)(97736003)(107046002)(36756003)(50986999)(54356999)(19580395003)(64706001)(106356001)(66066001)(7059020);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR05MB527;H:CO2PR05MB761.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <85E705623496614D91CD3FBDC0C53FB5@namprd05.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/30/14 1:17 PM, "Scott Wood" <scottwood@freescale.com> wrote:

>On Tue, 2014-09-30 at 20:15 +0000, Jojy Varghese wrote:
>> 
>> On 9/30/14 8:50 AM, "Guenter Roeck" <linux@roeck-us.net> wrote:
>> 
>> >On Mon, Sep 29, 2014 at 06:31:06PM -0500, Scott Wood wrote:
>> >> Which specific chip and revision did you see this on?  What is the
>>value
>> >> in MCSR?
>> >> 
>> >Jojy can answer that, at least for P5020. We have seen it on P5040 as
>> >well,
>> >though, so it is not just limited to one chip/revision.
>> 
>> The specifics are:
>> PVR: 0x80240012
>> Instruction that causes the MC exception: lwbrx
>> 	The faulty load address is also present in RB. So we could change the
>> logic to use that
>> instead of DEAR. What I don¹t know is of there are other cases also
>>which
>> escapes the current logic.
>
>Could you find out what MCSR was when that happened?  I'm most
>interested in whether MAV was set, but the other bits would be
>interesting as well.

MCSR=a000 ( Load Error Report)
>
>-Scott
>
>
Thanks
Jojy

