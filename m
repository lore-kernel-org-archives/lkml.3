Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaJ0UnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:43:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39943 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbaJ0UnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:43:14 -0400
Date: Mon, 27 Oct 2014 21:43:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: dougthompson@xmission.com, m.chehab@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, dinguyen@altera.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com,
        tthayer@altera.com
Subject: Re: [PATCHv2 0/4] Add Altera peripheral memories to EDAC framework
Message-ID: <20141027204307.GB4741@pd.tnic>
References: <1413578029-13205-1-git-send-email-tthayer@opensource.altera.com>
 <544E93F0.3030409@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <544E93F0.3030409@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 01:50:24PM -0500, Thor Thayer wrote:
> Do you have any comments about this driver?

Just a question: why do you have three .c files for something which
does only error injection and nothing else AFAICT? Why isn't this part
of altera_edac.c?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
