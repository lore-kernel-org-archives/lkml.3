Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaFSKMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 06:12:43 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:45922 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaFSKMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 06:12:41 -0400
Date: Thu, 19 Jun 2014 11:12:36 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        thierry.reding@gmail.com
Subject: Re: [STLinux Kernel] [PATCH 4/7] ARM: stih416-b2020e: Enable PWM on
 the B2020 Rev-E
Message-ID: <20140619101236.GA7390@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
 <1403103172-19856-4-git-send-email-lee.jones@linaro.org>
 <20140619090546.GB2131@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140619092042.GB26560@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619092042.GB26560@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> > Why are you only enabling this for rev-E board?
> 
> Purely for testing purposes, as it's the only board I have.  If
> anyone has the other revisions and would be happy to test the driver
> for me then great.

Ok that's what I suspected.

If you tell me how, I can test on a Rev C board. But as there are several other 
revisions I think checking the board schematics would be the quickest way forward.

> > If you make the stih415 DT PWM nodes part of this series as well, then 
> > assuming there is no good reason to the contary, the PWM could 
> > be enabled for both stih415/6 in the common stih41x-b2020 DTS file which
> > is also included by rev-E (assuming that PWM wiring is not some rev-E specific
> > thing).

Can you add the stih415 bindings in V2 as well?

regards,

Peter
