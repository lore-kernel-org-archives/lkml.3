Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3IZFG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:06:29 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:23499
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795Ab3IZFG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:06:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1453Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5243C0D1.4070808@freescale.com>
Date: Thu, 26 Sep 2013 13:06:25 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>
CC: Scott Wood <scottwood@freescale.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <ian.campbell@citrix.com>,
        <pawel.moll@arm.com>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <djbw@fb.com>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v10 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
References: <1379499333-4745-1-git-send-email-hongbo.zhang@freescale.com> <1379499333-4745-3-git-send-email-hongbo.zhang@freescale.com> <524074A7.7000001@wwwdotorg.org> <524169E3.7030408@freescale.com> <5241CC60.5070204@wwwdotorg.org> <52429252.10009@freescale.com> <1380159992.24959.248.camel@snotra.buserror.net> <20130926022859.GL9625@voom.redhat.com>
In-Reply-To: <20130926022859.GL9625@voom.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 10:28 AM, David Gibson wrote:
> On Wed, Sep 25, 2013 at 08:46:32PM -0500, Scott Wood wrote:
>> On Wed, 2013-09-25 at 15:35 +0800, Hongbo Zhang wrote:
>>> By the way, I know maybe it is difficult, but why not introduce a
>>> document of maintaining rules for the dt binding docs? we have dedicated
>>> maintainers for this part now. Description language from one submitter
>>> cannot satisfy every reviewer/maintainer, for a reg property, is it
>>> necessary to say "offset and length",
>> Don't say "offset and length".  It's both redundant with the base
>> definition of the reg property, and overly specific because it makes
>> assumptions about how the parent node's ranges are set up (sometimes we
>> want to be that specific, but usually not).

Thanks for your answer Scott.
In fact my questions are mainly sample questions to file the necessary 
rules of dt binding.
> To look at it another way, the format of the 'reg' property is defined
> by the parent bus's binding, not the binding of the node itself.
>
Whatever the rule is, if it is reasonable and accepted, just as I said, 
we need to file it.


