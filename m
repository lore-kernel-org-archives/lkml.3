Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaJZXYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 19:24:18 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:56517 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaJZXYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 19:24:16 -0400
Message-ID: <544D829A.40407@collabora.co.uk>
Date: Mon, 27 Oct 2014 00:24:10 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] regulator: max77802: Parse regulator operating
 mode properties
References: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk> <1413816472-1895-5-git-send-email-javier.martinez@collabora.co.uk> <20141022164813.GD2344@sirena.org.uk> <0DA944C5-7A6B-461B-A8E6-D47343D22E0B@collabora.co.uk> <20141024210214.GO3729@sirena.org.uk>
In-Reply-To: <20141024210214.GO3729@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

On 10/24/2014 11:02 PM, Mark Brown wrote:
> On Thu, Oct 23, 2014 at 11:28:09AM +0200, Javier Martinez Canillas wrote:
> 
> Please fix your mailer to word wrap within paragraphs - you should know
> this by now :/  I've reflowed for legibility.
> 

Sorry about that, I was on holidays last week and sent you that email from
my phone. Next time I'll wait until I've access to a mailer that I'm sure
does the right thing before answering you.

>> However this is an implementation detail and should not change the DT
>> bindings in the current version. Could you please let me know if you
>> have any issues with the other patches from this series so I can
>> address all of them when doing a re-spin?
> 
> I can't recall anything but I'm not sure I looked at them in any detail.
> 

Ok, thanks a lot for the feedback.

Best regards,
Javier
