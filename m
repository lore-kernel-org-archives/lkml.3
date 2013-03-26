Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3CZQz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:55:58 -0400
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:42466 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3CZQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:55:56 -0400
Message-ID: <5151D319.5040104@web.de>
Date: Tue, 26 Mar 2013 17:55:53 +0100
From: Danny Baumann <dannybaumann@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/1] drm/i915: Allow specifying a minimum brightness level
 for sysfs control.
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de> <1364298525-4337-2-git-send-email-dannybaumann@web.de> <20130326151313.GU9021@phenom.ffwll.local>
In-Reply-To: <20130326151313.GU9021@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1364316954-000004E7-36A545E0/0-0/0-0
X-Scan-AV: cora.hrz.tu-chemnitz.de;2013-03-26 17:55:54;ddc260a69d804a54086f9751d5898c53
X-Scan-SA: cora.hrz.tu-chemnitz.de;2013-03-26 17:55:54;7fc0f7f0a8d5e6da4d66c277ad3d3e85
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail provider
 *      (dannybaumann[at]web.de)
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Thus far our assumption always was that the acpi backlight works better
> than the intel native backlight. So everything only uses the intel
> backlight if there's no other backlight driver by default.
>
> So if I should merge this as a general solution for Windows 8 machines not
> working properly, we first need to figure out what windows does on these
> machines and either disable the acpi backlight or adapt it.

I fully agree to that. Making acpi_video control usable is preferable 
over using intel_backlight. As I lack the detail knowledge about the 
ACPI video stuff, I'd be great of one (or some) of you guys could look 
at the mentioned bug report ([1]) and comment on what the problem might 
be. I have added the basic needed information already and would be happy 
to provide any needed debugging info.

> Adding more kernel options is not a viable solution for the backlight mess
> imo.

Actually I'm fine with hardcoding the percentage as well ;) I just 
figured it might make sense to make it controllable for special-case 
uses, while still making intel_backlight usable for the 'normal' use case.

Regards,

Danny

[1] https://bugzilla.kernel.org/show_bug.cgi?id=55071
