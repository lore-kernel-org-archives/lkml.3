Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbaCMRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:21:23 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:24475 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbaCMRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:21:20 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(z579ehzbb2dI98dI9371Ic89bh936eI542I1432I4015I1447Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25f6h2605h906i1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: Michal Simek <michals@xilinx.com>, Soren Brinkmann <sorenb@xilinx.com>
CC: Michal Simek <michals@xilinx.com>, "monstr@monstr.eu" <monstr@monstr.eu>,
        Mark Rutland <mark.rutland@arm.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "kpc528@gmail.com" <kpc528@gmail.com>,
        "kalluripunnaiahchoudary@gmail.com" 
	<kalluripunnaiahchoudary@gmail.com>
Subject: RE: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
 controller
Thread-Topic: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
 controller
Thread-Index: AQHPPg4QHQoJNpsIckyMc2gxNXeg/5rdJBCAgAIgtdA=
Date: Thu, 13 Mar 2014 17:21:09 +0000
References: <4adb2b4b-2ad6-42b9-929e-cc062f817245@TX2EHSMHS021.ehs.local>
 <20140310105655.GH14999@e106331-lin.cambridge.arm.com>
 <531DA900.5060202@monstr.eu>
 <fa35006e-055d-4ef2-9b65-a0f8cc6a0c8f@AM1EHSMHS016.ehs.local>
 <531ECA33.8050803@monstr.eu> <20140311155057.GJ13293@xsjandreislx>
 <c7840b9d-4c03-4680-9a0e-fb256f3743b4@AM1EHSMHS010.ehs.local>
 <20140312161344.GA3000@xsjandreislx> <53209047.8070308@xilinx.com>
In-Reply-To: <53209047.8070308@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <5c399e76-42e4-4f8e-852e-91d88b229ae7@TX2EHSMHS006.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DHLYSs010870



>-----Original Message-----
>From: Michal Simek [mailto:michal.simek@xilinx.com]
>Sent: Wednesday, March 12, 2014 10:20 PM
>To: Soren Brinkmann
>Cc: Michal Simek; monstr@monstr.eu; Mark Rutland; Punnaiah Choudary
>Kalluri; dougthompson@xmission.com; devicetree@vger.kernel.org; linux-
>doc@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>kernel@vger.kernel.org; linux-edac@vger.kernel.org; robh+dt@kernel.org;
>Pawel Moll; ijc+devicetree@hellion.org.uk; galak@codeaurora.org;
>rob@landley.net; kpc528@gmail.com; kalluripunnaiahchoudary@gmail.com;
>Punnaiah Choudary Kalluri
>Subject: Re: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc
>controller
>
>On 03/12/2014 05:13 PM, SÃ¶ren Brinkmann wrote:
>> On Wed, 2014-03-12 at 11:27AM +0100, Michal Simek wrote:
>>> On 03/11/2014 04:50 PM, SÃ¶ren Brinkmann wrote:
>>>> On Tue, 2014-03-11 at 09:32AM +0100, Michal Simek wrote:
>>>>> On 03/10/2014 11:32 PM, SÃ¶ren Brinkmann wrote:
>>>>>> On Mon, 2014-03-10 at 12:58PM +0100, Michal Simek wrote:
>>>>>>> On 03/10/2014 11:56 AM, Mark Rutland wrote:
>>>>>>>> On Sun, Mar 09, 2014 at 02:57:16AM +0000, Punnaiah Choudary
>Kalluri wrote:
>>>>>>>>> Added EDAC support for reporting the ecc errors of zynq ddr
>controller.
>>>>>>>>> The ddr ecc controller corrects single bit errors and detects double
>bit
>>>>>>>>> errors
>>>>>>>>>
>>>>>>>>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>>>>>>>>> ---
>>>>>>>>>  .../devicetree/bindings/edac/zynq_edac.txt         |   18 +
>>>>>>>>>  drivers/edac/Kconfig                               |    7 +
>>>>>>>>>  drivers/edac/Makefile                              |    1 +
>>>>>>>>>  drivers/edac/zynq_edac.c                           |  613
>++++++++++++++++++++
>>>>>>>>>  4 files changed, 639 insertions(+), 0 deletions(-)
>>>>>>>>>  create mode 100644
>Documentation/devicetree/bindings/edac/zynq_edac.txt
>>>>>>>>>  create mode 100644 drivers/edac/zynq_edac.c
>>>>>>>>>
>>>>>>>>> diff --git
>a/Documentation/devicetree/bindings/edac/zynq_edac.txt
>b/Documentation/devicetree/bindings/edac/zynq_edac.txt
>>>>>>>>> new file mode 100644
>>>>>>>>> index 0000000..c21ff83
>>>>>>>>> --- /dev/null
>>>>>>>>> +++ b/Documentation/devicetree/bindings/edac/zynq_edac.txt
>>>>>>>>> @@ -0,0 +1,18 @@
>>>>>>>>> +Zynq EDAC driver, it does reports the DDR ECC single bit errors
>that are
>>>>>>>>> +corrected and double bit ecc errors that are detected by the DDR
>ECC controller.
>>>>>>>>> +ECC support for DDR is available in half-bus width(16 bit)
>configuration only.
>>>>>>>>> +
>>>>>>>>> +Required properties:
>>>>>>>>> +- compatible: Should be "xlnx,ps7-ddrc" or "xlnx,ps7-ddrc-1.00.a"
>>>>>>>>
>>>>>>>> Is this an or or a xor?
>>>>>>>
>>>>>>> Compatible string should be just xlnx,zynq-ddrc-1.00.a.
>>>>>>> Nothing with ps7.
>>>>>>
>>>>>> Isn't this vendor IP? IMHO, this should be something completely
>>>>>> different. Or if you want some Zynq-specific compat string it should
>>>>>> refer to an actual version string associated with Zynq. 1.00.a is not,
>>>>>> AFAIK.
>>>>>
>>>>> I have checked with Punnaiah that this is Synopsys DDR memory
>controller.
>>>>> Zynq is based on 1.4 version with some customization.
>>>>> It means I think reasonable solution is
>>>>> call it drivers/edac/synopsys_edac.c
>>>>> rename zynq_ in driver to synopsys_ and
>>>>> use xlnx,zynq-ddrc-1.00.a compatible string because zynq is not using
>>>>> clean synopsys version.
>>>>>
>>>>> I am not getting point why you don't like 1.00.a suffix here.
>>>>> Because of historical point of view compatible strings should be
>different
>>>>> for early silicon, silicon v1, silicon v2, silicon v3, etc
>>>>> but we haven't used it at all that's why we can use xilinx scheme
>>>>> which we are using for our soft IPs.
>>>>
>>>> Well, but you refer to Zynq which has silicon revisions you can use to
>>>> refer to a specific Zynq version. That matches data sheets. Zynq-1.00.a
>>>> is just completely made up and wouldn't be found in any data sheet.
>>>
>>> I didn't reply this one but we discussed this with Soren over phone.
>>> No problem to use Synopsys version A07 according TRM.
>>>
>>> Then compatible string is
>>> xlnx,zynq-ddrc-A07 and file name is synopsys_edac.c
>>
>> This seems to make sense. I'm never sure whether leading zeros are
>> actually needed and tend to remove them, but in general this looks like
>> a reasonable string to identify Zynq's DDR controller.
>
>A07 I found in Zynq TRM and probably has any conection to synopsys version
>scheme.
I have discussed with the design team and confirmed that the synopsis IP
version is 1.4 and looks like it is wrongly updated in TRM as A07.
So, I am going to use compatible string as xlnx,zynq-ddrc-1.4 and file name
as synopsys_edac.c and send you the updated patch soon.
Thanks for the review and suggestions

Regards,
Punnaiah
>
>Thanks,
>Michal
>
>
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
