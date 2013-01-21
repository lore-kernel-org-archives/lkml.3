Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3AUOhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:37:45 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:37751
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755388Ab3AUOhn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:37:43 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z21eIzbb2dI98dI9371Ic89bh1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h1155h)
X-WSS-ID: 0MGZCMK-02-8MY-02
X-M-MSG: 
Message-ID: <50FD52AB.9080000@amd.com>
Date: Mon, 21 Jan 2013 09:37:31 -0500
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
CC: Borislav Petkov <bp@alien8.de>, Udo van den Heuvel <udovdh@xs4all.nl>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic> <20130120115755.GO25591@8bytes.org>
In-Reply-To: <20130120115755.GO25591@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/20/2013 06:57 AM, Jörg Rödel wrote:
> On Sun, Jan 20, 2013 at 12:48:28PM +0100, Borislav Petkov wrote:
>> On Sun, Jan 20, 2013 at 12:40:11PM +0100, Jörg Rödel wrote:
>>> Yes, the BIOS vendor can fix this issue. They need to disable NB clock
>>> gating for the IOMMU.
>>
>> Right, Udo, you can try Gigabyte first.
>>
>> Btw, can't we add a quirk to disable NB clock gating? Maybe Boris and
>> Jacob could help. CCed.


Are you talking about erratum 746?

-boris


