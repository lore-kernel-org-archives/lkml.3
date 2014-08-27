Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbaH0GhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:37:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49255 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaH0GhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:37:15 -0400
Date: Wed, 27 Aug 2014 08:36:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Thor Thayer <tthayer@opensource.altera.com>, Pavel Machek <pavel@denx.de>,
        robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@opensource.altera.com,
        delicious.quinoa@gmail.com, dougthompson@xmission.com,
        grant.likely@linaro.org, sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, tthayer.linux@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Subject: Re: [PATCHv10 2/2] arm: dts: Add Altera SDRAM EDAC bindings &
 devicetree entries.
Message-ID: <20140827063638.GA28234@nazgul.tnic>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
 <1407770293-27190-3-git-send-email-tthayer@opensource.altera.com>
 <20140814184949.GC11558@amd.pavel.ucw.cz>
 <53FCD456.3050404@opensource.altera.com>
 <53FCEDDA.4060906@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53FCEDDA.4060906@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 03:28:10PM -0500, Dinh Nguyen wrote:
> If Boris is okay with driver part and everyone else is OK with the DTS
> portion, then I can apply the DTS patch to my tree, and Boris take the
> driver patch into his tree?

Actually, it would be easier for everyone involved if those patches go
together due to their dependency. So if you want me to take a look at
the EDAC parts again and give you my ack so that you can pick them all
up together and they go through your tree, let me know.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
