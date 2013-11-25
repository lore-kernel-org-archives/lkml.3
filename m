Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab3KYPAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:00:09 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65359 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3KYPAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:00:03 -0500
Date: Mon, 25 Nov 2013 15:59:58 +0100
From: Julian Andres Klode <jak@jak-linux.org>
To: Julian Andres Klode <jak@jak-linux.org>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131125145958.GA13564@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:56:29PM +0100, Julian Andres Klode wrote:
> This patch series adds support for specifying charging thresholds,
> forcing a battery to discharge, and inhibiting charging, on ThinkPad
> Laptops using Sandy Bridge or newer processors.
> 
> The first two patches should be stable now, the third one does not work on
> my test system (but I'd appreciate if anyone with something other than an
> X230 tests it). 
> 
> The inhibit charging part is a bit unprecise, and I can obviously not test
> that -1 really means permanently, but I assume it does. I don't know whether
> this one should be merged.
> 
> Changes since the RFC PATCH:
>   - Define batteries more dynamically instead of statically using large
>     macros. Added support for up to 3 batteries, unsupported ones will not
>     be exported.
>   - Added 3 more new patches with more features
> 
> Julian Andres Klode (4):
>   thinkpad_acpi: Add support for controlling charge thresholds
>   thinkpad_acpi: battery: Add force_discharge attribute
>   thinkpad_acpi: battery: Add force_discharge_ac_break attribute
>   thinkpad_acpi: battery: Add inhibit_charge_minutes attribute
> 
>  Documentation/laptops/thinkpad-acpi.txt |  37 ++++
>  drivers/platform/x86/thinkpad_acpi.c    | 300 ++++++++++++++++++++++++++++++++
>  2 files changed, 337 insertions(+)
> 

I'd really like to get some comments on this series (especially by Henrique
and Matthew, they're responsible); so I know what I have to fix and whether
I should drop some of the later patches, and if the patch series has any
chance of being accepted...

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
