Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3IXIMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:12:03 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:59706 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab3IXIL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:11:58 -0400
Message-ID: <5241488F.5010000@st.com>
Date: Tue, 24 Sep 2013 09:08:47 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: st-rc: Add ST remote control driver
References: <1379581176-25078-1-git-send-email-srinivas.kandagatla@st.com> <5240A740.7000407@wwwdotorg.org>
In-Reply-To: <5240A740.7000407@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Stephen,
On 23/09/13 21:40, Stephen Warren wrote:
> On 09/19/2013 02:59 AM, Srinivas KANDAGATLA wrote:
>> This patch adds support to ST RC driver, which is basically a IR/UHF
>> receiver and transmitter. This IP (IRB) is common across all the ST
>> parts for settop box platforms. IRB is embedded in ST COMMS IP block.
>> It supports both Rx & Tx functionality.
>>
>> In this driver adds only Rx functionality via LIRC codec.
> 
>> diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/media/st-rc.txt
> 
>> +Required properties:
>> +	- compatible: should contain "st,comms-irb".
>> +	- reg: base physical address of the controller and length of memory
>> +	mapped  region.
> 
> Nits:
> 
> The indentation is a little odd here; I'd expect the - to be in column
> 1, at least that's how most other binding docs are written. Not a big
> deal though.
> 
> It'd be nice to indent the continuation lines (e.g. "mapped region") a
> bit more so it's easier to see where each new entry starts.
> 
> There are two spaces in "mapped  region".
I should have noticed it... I will fix it in next version.
> 
>> +	- rx-mode: can be "infrared" or "uhf". rx-mode should be present iff the
>> +	  rx pins are wired up.
>> +	- tx-mode: should be "infrared". tx-mode should be present iff the tx
>> +	  pins are wired up.
> 
> Should those property names be prefixed with "st,"; I assume they're
> specific to this binding rather than something generic that applies to
> all IR controller bindings? If you expect them to be generic, it's fine.

Officially these bindings are not specified in ePAPR specs but I see no
reason for not having these properties as generic ones.

Are you ok with that?

> 
>> +	- clocks : phandle with clock-specifier pair.
> 
> For what clock?
Its Clock for IRB block. I will add this in next version.
> 
> 

Thanks,
srini

