Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaI3P77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 11:59:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49926 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaI3P75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 11:59:57 -0400
Date: Tue, 30 Sep 2014 17:59:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        linux-pci@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pci_ids: Add PCI device IDs for F15h M60h
Message-ID: <20140930155952.GG4639@pd.tnic>
References: <1411070195-10177-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
 <20140919053126.GC21128@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140919053126.GC21128@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:31:26PM -0600, Bjorn Helgaas wrote:
> On Thu, Sep 18, 2014 at 02:56:35PM -0500, Aravind Gopalakrishnan wrote:
> > Add F3, F4 device IDs to be used in amd_nb.c and amd64_edac.c
> > 
> > Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Please merge this along with the rest of your series.

Queued for 3.19, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
