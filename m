Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3J2Idl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:33:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37685 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3J2Idf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:33:35 -0400
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131029010608.GA5353@earth.universe>
Date: Tue, 29 Oct 2013 03:33:31 -0500
Cc: linux-input@vger.kernel.org,
        =?iso-8859-1?Q?=22=27Beno=EEt_Cousson=27=22?= 
	<bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <14DEC9DA-8C77-4F73-AF3A-6C0D20C6C1AB@codeaurora.org>
References: <1382446042-27099-1-git-send-email-sre@debian.org> <1382446042-27099-2-git-send-email-sre@debian.org> <5137C017-2515-427C-865F-B938CC24B210@codeaurora.org> <20131029010608.GA5353@earth.universe>
To: Sebastian Reichel <sre@debian.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28, 2013, at 8:06 PM, Sebastian Reichel wrote:

> On Mon, Oct 28, 2013 at 01:42:47AM -0500, Kumar Gala wrote:
>>> +This binding is based on the matrix-keymap binding with the following
>>> +changes:
>> 
>> Maybe be a bit more specific and say 'based on the input/matrix-keymap.txt binding'..
> 
> OK.
> 
>>> + * keypad,num-rows and keypad,num-columns are required.
>> 
>> Is linux,keymap required from matrix-keymap.txt?
> 
> Yes, matrix-keymap.txt contains descriptions for the following:
> 
> required:
> - linux,keymap

So you don't say that linux,keymap is required for twl4030-keypad (wasn't clear if you assumed that or not).

> optional:
> - keypad,num-rows
> - keypad,num-columns
> 
>>> +Optional Properties specific to linux:
>>> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
>> 
>> Does it make sense to update the matrix-keymap.txt binding to add
>> 'linux,keypad-no-autorepeat' there?
> 
> At least according to devicetree documentation there are
> keymap-matrix.txt based drivers, which do not support
> "linux,keypad-no-autorepeat".

Which is why it could be optional in keymap-matrix.txt.  I dont know anything about keymap/keypad's just asking the question?

It seems as if linux,keypad-no-autorepeat is intended to mean the same thing (if relevant to the device) across all drivers.  Is that correct?  If so it seems like moving it to be specified in a generic input binding makes sense, just not sure if keymap-matrix.txt is that place or not.

- k
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

