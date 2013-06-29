Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3F2XRO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:17:14 -0400
Received: from mouse.start.ca ([64.140.120.56]:50689 "EHLO mouse.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab3F2XRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:17:10 -0400
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jun 2013 19:17:10 EDT
Message-ID: <51CF6776.7090206@start.ca>
Date: Sat, 29 Jun 2013 19:02:14 -0400
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ondrej Zary <linux@rainbow-software.org>, Pavel Machek <pavel@ucw.cz>,
        Mark Lord <mlord@pobox.com>,
        Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <51C76858.4060906@pobox.com> <20130623215100.GA7414@amd.pavel.ucw.cz> <201306240914.29502.linux@rainbow-software.org> <20130629184716.GA9330@khazad-dum.debian.net>
In-Reply-To: <20130629184716.GA9330@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-29 02:47 PM, Henrique de Moraes Holschuh wrote:
> You know, either the "long" or the "offline" SMART test routines do exactly
> that on any spinning rust device with a firmware that is not utterly broken.
> 
> The HDD's firmware will rewrite, and even reallocate any "weak" sectors
> found by the surface scan.
> 

The drives I have tried this on (smartctl -t long),
abort at the first bad sector.  Not useful.

