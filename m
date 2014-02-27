Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaB0RNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:13:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47216 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbaB0RNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:13:24 -0500
Date: Thu, 27 Feb 2014 18:13:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dougthompson@xmission.com, bhelgaas@google.com, JBeulich@suse.com,
        dan.carpenter@oracle.com, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-pci@vger.kernel.org,
        Arindam.Nath@amd.com
Subject: Re: [PATCH] amd64_edac: Add support for newer F16h models
Message-ID: <20140227171317.GL18191@pd.tnic>
References: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1392913726-16961-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:28:46AM -0600, Aravind Gopalakrishnan wrote:
> Extending ECC decoding support for F16h M30h.
> 
> Tested on F16h M30h with ECC turned on using mce_amd_inj module and
> the patch works fine.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> Tested-by: Arindam Nath <Arindam.Nath@amd.com>

Added hpa's ack and applied,

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
