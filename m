Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaKGQvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:51:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49395 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKGQvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:51:40 -0500
Date: Fri, 7 Nov 2014 17:51:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Thor Thayer <tthayer@opensource.altera.com>, dougthompson@xmission.com,
        m.chehab@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com
Subject: Re: [PATCHv3 4/5] edac: altera: Add Altera L2 Cache and OCRAM EDAC
 Support
Message-ID: <20141107165134.GA5139@pd.tnic>
References: <1414683131-20786-1-git-send-email-tthayer@opensource.altera.com>
 <1414683131-20786-5-git-send-email-tthayer@opensource.altera.com>
 <20141104151214.GD9570@pd.tnic>
 <545959E8.2040005@opensource.altera.com>
 <20141106163134.GF4318@pd.tnic>
 <545CF3D8.1020500@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <545CF3D8.1020500@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:31:20AM -0600, Dinh Nguyen wrote:
> If it's okay, can you please pick up this series, once everything is
> cleaned up? I just checked to make sure that there aren't any merge
> conflicts in the DTS files in this series against DTS patches that I
> have queue up for 3.19, and there aren't.

Sure, but I'd need ACKs from you/the relevant maintainers for 1/5, 2/5
and 5/5 patches.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
