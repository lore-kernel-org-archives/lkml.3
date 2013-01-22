Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3AVQMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:12:36 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:31837
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754021Ab3AVQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:12:35 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(z21eIzbb2dI98dI9371I936eI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-WSS-ID: 0MH1BOQ-01-4CH-02
X-M-MSG: 
Message-ID: <50FEBA69.60106@amd.com>
Date: Tue, 22 Jan 2013 11:12:25 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: <suravee.suthikulpanit@amd.com>, Jacob Shin <jacob.shin@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450 <50FE9E76.30702@xs4all.nl> <50FEA3F2.1070408@amd.com> <50FEAFEB.7020103@xs4all.nl>
In-Reply-To: <50FEAFEB.7020103@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/22/2013 10:27 AM, Udo van den Heuvel wrote:
> On 2013-01-22 15:36, Boris Ostrovsky wrote:
>>> Gigabyte demonstrate that using ESX 5i IOMMU works fine. (with pictures
>>> attached).
>>
>> There are no attachments to your message.
>
> Correct, gigabyte did send them via their support web-interface.
> Do yo uneed to see them? They just show IOMMU enabled or similar.

No, I thought you ran this yourself.

>
>>> What can we bring against that?
>>
>> How reproducible is the problem that you are seeing?
>
> Seen once over here. Correlated with raid-check.

Then the answer from Gigabyte doesn't prove anything. You can also boot 
Linux without seeing this problem in most cases.

Your BIOS does not have the required erratum workaround. We will provide 
a patch to close that hole but since the problem is not easily 
reproducible (and the erratum is also not easy to trigger) it may be 
difficult to say whether it really helped with your problem.

-boris

