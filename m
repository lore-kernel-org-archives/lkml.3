Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab3CTMsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:48:08 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57071 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932496Ab3CTMsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:48:05 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Philip Avinash <avinashphilip@ti.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>
Subject: Re: [PATCH v2 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1363761714-15034-1-git-send-email-avinashphilip@ti.com>
	<1363761714-15034-4-git-send-email-avinashphilip@ti.com>
	<51499DB4.9080907@ti.com>
Date: Wed, 20 Mar 2013 13:47:59 +0100
In-Reply-To: <51499DB4.9080907@ti.com> (Sekhar Nori's message of "Wed, 20 Mar
	2013 16:59:56 +0530")
Message-ID: <87wqt2qlts.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sekhar" == Sekhar Nori <nsekhar@ti.com> writes:

 Sekhar> On 3/20/2013 12:11 PM, Philip Avinash wrote:
 >> Add da850 EHRPWM & ECAP DT node.
 >> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
 >> clock.
 >> 
 >> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
 >> ---
 >> Changes since v1:
 >> - Reusing ti,am33xx<ecap/ehrpwm> as compatible field as both IP's are
 >> same with am33xx platform and da850 has no platform specific
 >> dependency.

 Sekhar> Which is fine, but I think the binding documentation still needs to be
 Sekhar> updated to document the ti,da850-ehrpwm binding. Looping Peter (it is
 Sekhar> always a good idea to CC folks who reviewed your patch last time
 Sekhar> around). Also, please Cc the DT folks and devicetree-discuss list too
 Sekhar> for their opinion.

Yes, thanks for CC'ing me. I also think da850-* should be
documented. See Documentation/devicetree/bindings/gpio/8xxx_gpio.txt for
an similar (old) example.

-- 
Bye, Peter Korsgaard
