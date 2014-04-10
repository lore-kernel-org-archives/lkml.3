Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161222AbaDJV11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:27:27 -0400
Received: from sam.nabble.com ([216.139.236.26]:56009 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107AbaDJV10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:27:26 -0400
Date: Thu, 10 Apr 2014 14:27:25 -0700 (PDT)
From: =?UTF-8?Q?J=C3=B6rg_Krause?= <jk@lintech.de>
To: linux-kernel@vger.kernel.org
Message-ID: <1397165245229-838046.post@n7.nabble.com>
In-Reply-To: <5337DC2E.5040000@broadcom.com>
References: <1392059868-8782-1-git-send-email-arend@broadcom.com> <52FC8CB3.4090305@gmail.com> <CAGb2v67za+5yW3RE0pwBWk-NdTUSm-JkKE+j9NLjbBkE_Fc1hQ@mail.gmail.com> <5337DC2E.5040000@broadcom.com>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio
 devices
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/14 10:28, Chen-Yu Tsai wrote:
> Hi,
>
> On Thu, Feb 13, 2014 at 5:13 PM, Tomasz Figa&lt;tomasz.figa@&gt;  wrote:
>> Hi Arend,
>>
>>
>> On 10.02.2014 20:17, Arend van Spriel wrote:

[...]

Hi Chen-Yu,

picking up this thread.

> AFAIK, the pinctrl in tied to the device node, and is selected when the
> device
> is registered. The MMC subsystem currently does not register child nodes,
> so
> this would be useless.

So if MMC does not register child nodes, brcmfmac will not be probed 
with of_node set? Have there been patches submitted for this in mmc 
subsystem recently.

[...]



Sascha Hauer submitted a patch a week ago. Link: 
https://lkml.org/lkml/2014/4/3/522 <https://lkml.org/lkml/2014/4/3/522>  




--
View this message in context: http://linux-kernel.2935.n7.nabble.com/RFC-dt-bindings-add-bindings-for-Broadcom-bcm43xx-sdio-devices-tp801976p838046.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
