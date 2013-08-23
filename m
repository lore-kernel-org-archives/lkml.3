Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3HWDSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 23:18:12 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:5546
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312Ab3HWDSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 23:18:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h1155h)
Message-ID: <5216D461.4010604@freescale.com>
Date: Fri, 23 Aug 2013 11:17:53 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Scott Wood <scottwood@freescale.com>, <vinod.koul@intel.com>,
        <djbw@fb.com>, <leoli@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/3] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>  <1375094944-3343-3-git-send-email-hongbo.zhang@freescale.com>  <521541EE.4010303@wwwdotorg.org> <1377126028.5029.52.camel@snotra.buserror.net> <52154A34.4020405@wwwdotorg.org>
In-Reply-To: <52154A34.4020405@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 07:16 AM, Stephen Warren wrote:
> On 08/21/2013 05:00 PM, Scott Wood wrote:
>> On Wed, 2013-08-21 at 16:40 -0600, Stephen Warren wrote:
>>> On 07/29/2013 04:49 AM, hongbo.zhang@freescale.com wrote:
>>>> +        - reg               : <registers mapping for channel>
>>>> +        - interrupts        : <interrupt mapping for DMA channel IRQ>
>>> s/interrupts/specifier/
>> Do you mean s/interrupt mapping/interrupt specifier/?
>>
>> And probably s/registers mapping/register specifier/ as well.
> Yup.
>
OK, I will update these descriptions.



