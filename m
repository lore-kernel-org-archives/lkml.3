Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbaJ3OyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:54:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40667 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760411AbaJ3OyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:54:02 -0400
Date: Thu, 30 Oct 2014 15:53:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] edac, amd64_edac: Add F15h M60h support
Message-ID: <20141030145355.GC11178@pd.tnic>
References: <1414617483-4941-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20141030124528.GB11178@pd.tnic>
 <54524123.1020407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54524123.1020407@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 08:46:11AM -0500, Aravind Gopalakrishnan wrote:
> Because it gets printed anyway when we do
> edac_dbg(1, "  DIMM type: %s\n", edac_mem_types[pvt->dram_type]);

Ah, true.

Ok, patch queued for 3.19.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
