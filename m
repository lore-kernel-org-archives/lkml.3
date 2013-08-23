Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3HWTk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 15:40:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54170 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3HWTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 15:40:23 -0400
Message-ID: <5217BAA3.4080202@wwwdotorg.org>
Date: Fri, 23 Aug 2013 13:40:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Fabian Vogt <fabian@ritter-vogt.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for LSI ZEVIO SoCs
References: <op.w1c50xgmu7prd4@fabians-laptop.fritz.box> <CACRpkdbLSDiSAGiZ_PpJganrSoar+2fFPaEjbu_L1Ezx5V8DMg@mail.gmail.com> <op.w1w4bifku7prd4@fabians-laptop.fritz.box> <CACRpkdbUoOP9DH59=MQ71tKGJ+OLFd0E7-iz7ZSM4owsTxcWWw@mail.gmail.com>
In-Reply-To: <CACRpkdbUoOP9DH59=MQ71tKGJ+OLFd0E7-iz7ZSM4owsTxcWWw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2013 08:09 AM, Linus Walleij wrote:
> On Fri, Aug 16, 2013 at 6:34 PM, Fabian Vogt <fabian@ritter-vogt.de> wrote:
>> On Fri, Aug 16, 2013 at 4:46 PM, Linus Walleij <linus.walleij@linaro.org>
>> wrote:
> 
>>> I want an ACK from one of the DT bindings maintainers for this
>>> portion of the driver ideally. (It looks all right to me.)
>>
>> Any ideas which mail addresses I should add to CC:?
> 
> No. devicetree@vger.kernel.org is the place.
> 
> But if nothing happens you might want to ask Stephen Warren.

The full list of CC's is:

OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
M:      Rob Herring <rob.herring@calxeda.com>
M:      Pawel Moll <pawel.moll@arm.com>
M:      Mark Rutland <mark.rutland@arm.com>
M:      Stephen Warren <swarren@wwwdotorg.org>
M:      Ian Campbell <ian.campbell@citrix.com>
L:      devicetree@vger.kernel.org

