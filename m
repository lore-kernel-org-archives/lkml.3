Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3JJMqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:46:03 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2563 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3JJMqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:46:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 Oct 2013 05:41:48 -0700
Message-ID: <5256A773.6060807@nvidia.com>
Date: Thu, 10 Oct 2013 18:41:15 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v6] extcon: palmas: Added a new compatible type *ti,palmas-usb-vid*
References: <1381408647-24653-1-git-send-email-kishon@ti.com>
In-Reply-To: <1381408647-24653-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 October 2013 06:07 PM, Kishon Vijay Abraham I wrote:
> The Palmas device contains only a USB VBUS-ID detector, so added a
> compatible type *ti,palmas-usb-vid*. Didn't remove the existing compatible
> types for backward compatibility.
>
I dont have much issue on this nomenclature but just second thought:

The Palmas USB module is capable of detection VBUS, ID-GND, ID-RA, 
ID-RB, ID-RC and ID-FLOAT as per BC1.2.
This sub-module only detect the cable, does nothing more than this.
In this case, should we say "ti,palmas-usb-extcon"?
Again extcon is linux specific terminology and this can be defer.


