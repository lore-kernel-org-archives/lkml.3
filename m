Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaFMIaR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:30:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35814 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaFMIaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:30:15 -0400
Date: Fri, 13 Jun 2014 10:30:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: WANG Chao <chaowang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140613083012.GC4751@pd.tnic>
References: <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613080028.GK15034@dhcp-17-89.nay.redhat.com>
 <20140613081050.GB4751@pd.tnic>
 <20140613082459.GL15034@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140613082459.GL15034@dhcp-17-89.nay.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 04:24:59PM +0800, WANG Chao wrote:
> Emm.. I'm not sure, but I think there might be a chance that
> COMMAND_LINE_SIZE extend in the future. In general 8K is safe to use,
> because the current greatest one is 4K.

Sure, but kexec cannot load a kernel of different arch, can it?
Which means, we're safe using the arch-specific definition of
COMMAND_LINE_SIZE.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
