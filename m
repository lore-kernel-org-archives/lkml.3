Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3HUG71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:59:27 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9238 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100Ab3HUG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:59:26 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah1de096h8275bh8275dh1de097hz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h1155h)
Message-ID: <5214653E.4080105@freescale.com>
Date: Wed, 21 Aug 2013 14:59:10 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, <devicetree@vger.kernel.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>
CC: <djbw@fb.com>, <leoli@freescale.com>, <scottwood@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>
Subject: Re: [PATCH v7 0/3] DMA: Freescale: Add support for 8-channel DMA
 engine
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com> <20130729105901.GI29095@intel.com> <521329EA.3050900@freescale.com> <20130820081522.GC5810@intel.com>
In-Reply-To: <20130820081522.GC5810@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi DT maintainers,
Rob Herring, Pawel Moll, Mark Rutland, Stephen Warren, Ian Campbell, 
could you please have a look at [1/3] and [2/3] of these patch set.
These patches have been fully reviewed by Scott Wood, and the DMA 
maintainer Vinod needs a Acted-by: from DT maintainers.
Thanks.

On 08/20/2013 04:15 PM, Vinod Koul wrote:
> On Tue, Aug 20, 2013 at 04:33:46PM +0800, Hongbo Zhang wrote:
>> On 07/29/2013 06:59 PM, Vinod Koul wrote:
>>> On Mon, Jul 29, 2013 at 06:49:01PM +0800, hongbo.zhang@freescale.com wrote:
>>>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>>>
>>>> Hi Vinod, Dan, Scott and Leo, please have a look at these V7 patches.
>>> The dma relates changes look okay to me.
>>>
>>> I need someone to review and ACK the DT bindings.
>>>
>>> ~Vinod
>> Vinod,
>> Are you using this tree?
>> http://git.infradead.org/users/vkoul/slave-dma.git
> Yes
>
>> Did you merge these patches?
> No
>
> As I said I would like someone who know DT and dma binding to ack them. I see
> devicetree ML has been cced, can Arnd or someone else review these...
>
> ~Vinod
>



