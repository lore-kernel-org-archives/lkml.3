Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3KOJvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 04:51:36 -0500
Received: from mail.southpole.se ([37.247.8.11]:45670 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3KOJvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 04:51:32 -0500
Message-ID: <5285EED9.6090401@southpole.se>
Date: Fri, 15 Nov 2013 10:52:25 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Mehall <contact@kevinmehall.net>,
        linux@openrisc.net
Subject: Re: [ORLinux] [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org> <20131110055145.GA7947@chokladfabriken.org>
In-Reply-To: <20131110055145.GA7947@chokladfabriken.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.3.3(13276) on assp.southpole.se
X-Assp-ID: assp.southpole.se 09090-04339
X-Assp-Session: 7F739B635E40 (mail 1)
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2013 06:51 AM, Stefan Kristiansson wrote:
> On Sat, Nov 09, 2013 at 09:37:31PM +0100, Geert Uytterhoeven wrote:
>> Notable changes:
>>    - Change flash0 to spansion,s25sl064p, due to kernel message
>>      m25p80 spi32766.0: found s25sl064p, expected m25p10
>
> This is due to Altera changing the EPCS chip on newer revisions
> of that board, older versions are "relabeled" m25p10 and
> newer once s25sl064p.
> The change is fine though, you have to pick one.

Actually, you want two DTS's: one for each version of the board with a 
'compatible' property to help select the right one.  What do the 
revision numbers for these boards look like?

/Jonas
