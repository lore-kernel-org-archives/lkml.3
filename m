Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaGJQtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:49:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42464 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaGJQt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:49:29 -0400
Date: Thu, 10 Jul 2014 18:49:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 5/6] x86-mce: check if no_way_out applies before deciding
 not to clear MCE banks.
Message-ID: <20140710164921.GB5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-6-git-send-email-hskinnemoen@google.com>
 <3908561D78D1C84285E8C5FCA982C28F328574C3@ORSMSX114.amr.corp.intel.com>
 <CAFQmdRb9vsWyF06jppS5U7Wzuc+SzRgWL+hs5+es-GC=5e_8qg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F32857896@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32857896@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 11:27:07PM +0000, Luck, Tony wrote:
> > to run with tolerant=3, but I kind of understood the logic to be that
> > if we're going to keep running, we need to clear the banks, and if
> > we're going to crash, we need to leave them intact 
> 
> That makes sense ... fold some text like that into the commit
> description, and this part is:
> 
> Acked-by: Tony Luck <tony.luck@intel.com>

Yep, makes sense.

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
