Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3AVOgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:36:41 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:38556
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372Ab3AVOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:36:39 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z21eIzbb2dI98dI9371I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h1155h)
X-WSS-ID: 0MH178X-02-CA9-02
X-M-MSG: 
Message-ID: <50FEA3F2.1070408@amd.com>
Date: Tue, 22 Jan 2013 09:36:34 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: <suravee.suthikulpanit@amd.com>, Jacob Shin <jacob.shin@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic>  <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org>  <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org>  <20130120114828.GB16519@pd.tnic> <20130121160450 <50FE9E76.30702@xs4all.nl>
In-Reply-To: <50FE9E76.30702@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/22/2013 09:13 AM, Udo van den Heuvel wrote:
> Gigabyte demonstrate that using ESX 5i IOMMU works fine. (with pictures
> attached).

There are no attachments to your message.

I am not sure that 5i supports IOMMU (but I may well be wrong).

>
> What can we bring against that?

How reproducible is the problem that you are seeing?


-boris

