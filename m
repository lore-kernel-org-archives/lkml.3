Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaHANNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:13:53 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:50637 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaHANNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:13:52 -0400
Message-ID: <53DB9292.7080008@cogentembedded.com>
Date: Fri, 01 Aug 2014 17:13:54 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, nsekhar@ti.com, robh+dt@kernel.org
CC: devicetree@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: DTS: da850-evm: Add node for tlv320aic3106 codec
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com> <1406801934-23334-6-git-send-email-peter.ujfalusi@ti.com> <53DA519A.4090905@cogentembedded.com> <53DB240F.2030908@ti.com> <53DB8CEA.9010902@cogentembedded.com> <53DB8FE1.5010207@ti.com>
In-Reply-To: <53DB8FE1.5010207@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/01/2014 05:02 PM, Peter Ujfalusi wrote:

>>     I do. We should follow the standard consistently. Why not call the node
>> "sound-codec"?

> Well, there is _zero_ cases when the audio codec node is named as
> "sound-codec" in linux-next but we have wmXXXX, tlvXXXX, twlXXXX, maxXXXX etc.

    Which only means people don't read the standard (which is referred to on 
http://www.devicetree.org/Device_Tree_Usage, that says the same).

> Yeah, there are few DTS files which have codec as node name.
> So, no, I'm not going to change the node name from tlv320aic3106.

    So you prefer following the bad examples to following the standard? Well, 
"the Moor has done his duty, the Moor can go"...

WBR, Sergei

