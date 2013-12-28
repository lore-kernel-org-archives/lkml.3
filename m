Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab3L1VKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 16:10:32 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:47064 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3L1VKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 16:10:31 -0500
Date: Sat, 28 Dec 2013 22:10:26 +0100
From: Julian Andres Klode <jak@jak-linux.org>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131228211026.GA14725@jak-x230>
Mail-Followup-To: Julian Andres Klode <jak@jak-linux.org>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Matthew Garrett <matthew.garrett@nebula.com>,
	"open list:THINKPAD ACPI EXT..." <ibm-acpi-devel@lists.sourceforge.net>,
	"open list:THINKPAD ACPI EXT..." <platform-driver-x86@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:56:29PM +0100, Julian Andres Klode wrote:
> This patch series adds support for specifying charging thresholds,
> forcing a battery to discharge, and inhibiting charging, on ThinkPad
> Laptops using Sandy Bridge or newer processors.

Hello again,

it's been about 1.5 months now after I submitted this patch series
and I have not received any response yet.

I fixed the issues pointed out by Bjørn Mork in the previous patch
except for the one with the battery names, as I have no idea how
battery numbers are created or mapped. I can only say that the names
are the same on my test machine, I don't have any other ones.

Henrique, it would be really great if you could take a look.
-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Please do not top-post if possible.
