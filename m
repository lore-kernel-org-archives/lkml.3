Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKCRqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:46:42 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:21231 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaKCRqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:46:39 -0500
Message-ID: <5457BF7A.4060105@atmel.com>
Date: Mon, 3 Nov 2014 18:46:34 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Vinod Koul <vinod.koul@intel.com>, <dmaengine@vger.kernel.org>,
        <lars@metafoo.de>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH v4 02/58] serial: at91: Use dmaengine_slave_config API
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com> <1414531573-18807-3-git-send-email-maxime.ripard@free-electrons.com> <5457632C.5020002@atmel.com> <20141103123311.GJ11263@lukather>
In-Reply-To: <20141103123311.GJ11263@lukather>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 13:33, Maxime Ripard :
> Hi Nicolas,
> 
> On Mon, Nov 03, 2014 at 12:12:44PM +0100, Nicolas Ferre wrote:
>> On 28/10/2014 22:25, Maxime Ripard :
>>> We are removing the dmaengine_device_control API, that shouldn't even have been
>>> exposed in the first place. Change the callers to use the proper API.
>>>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> Thanks, Maxime. Do I have to carry the patch myself or is it part of a
>> series?
> 
> I think it would be better to keep it together with that serie, since
> we're removing dmaengine_device_control in a latter patch. If it's ok
> for you of course.

Fair enough, keep it in.

Thanks Maxime, bye,
-- 
Nicolas Ferre
