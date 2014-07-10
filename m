Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaGJIRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:17:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50084 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaGJIRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:17:04 -0400
Date: Thu, 10 Jul 2014 10:16:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
Message-ID: <20140710081655.GA2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
 <87a98inucv.fsf@tassilo.jf.intel.com>
 <CAFQmdRZejRwbk90kZoN777EO+a5VN8+AaXcjeqLzSBT6U2QfRw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328578D2@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328578D2@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 11:32:53PM +0000, Luck, Tony wrote:
> *) AMD cpus (they don't do CMCI at all, do they??)

They have something similar. See arch/x86/kernel/cpu/mcheck/mce_amd.c

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
