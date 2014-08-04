Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHDJMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:12:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53647 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaHDJMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:12:13 -0400
Message-ID: <53DF4DE4.3090305@ti.com>
Date: Mon, 4 Aug 2014 12:09:56 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <nsekhar@ti.com>,
        <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux@arm.linux.org.uk>, <pawel.moll@arm.com>,
        <khilman@deeprootsystems.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/6] ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com>	<1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com>	<53DA519A.4090905@cogentembedded.com> <53DB240F.2030908@ti.com>	<53DB8CEA.9010902@cogentembedded.com> <53DB8FE1.5010207@ti.com>	<53DB9292.7080008@cogentembedded.com> <53DB9751.6030508@ti.com>
In-Reply-To: <53DB9751.6030508@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 04:34 PM, Peter Ujfalusi wrote:
> Hi,
> 
> On 08/01/2014 04:13 PM, Sergei Shtylyov wrote:
>> Hello.
>>
>> On 08/01/2014 05:02 PM, Peter Ujfalusi wrote:
>>
>>>>     I do. We should follow the standard consistently. Why not call the node
>>>> "sound-codec"?
>>
>>> Well, there is _zero_ cases when the audio codec node is named as
>>> "sound-codec" in linux-next but we have wmXXXX, tlvXXXX, twlXXXX, maxXXXX etc.
>>
>>    Which only means people don't read the standard (which is referred to on
>> http://www.devicetree.org/Device_Tree_Usage, that says the same).
>>
>>> Yeah, there are few DTS files which have codec as node name.
>>> So, no, I'm not going to change the node name from tlv320aic3106.
>>
>>    So you prefer following the bad examples to following the standard?
> 
> those bad examples are in the tree and they did went through the review
> process (arch, DT and probably alsa). But it is interesting that we do not
> have a single correct node name for audio codecs (probably for other types also).

I have thought about this over the weekend and I would keep the node name for
the codec as it is in the patch.
It is the common practice for audio and it also helps when reading the DT file
to quickly see the audio support on the board. We all use the 'sound' node
name for audio cards and when we use the name of the codec as node name we do
not need to look further in the dts file to see what is the codec in used (and
what/which cpu dai we are using). All this can be seen in the main sound
support node.

>> Well, "the Moor has done his duty, the Moor can go"...
> 
> Let's ask the DT maintainers what should be the correct approach and someone
> should go through all the existing DT files and clean them up? People usually
> start reading the code for examples before the standard...
> 


-- 
Péter
