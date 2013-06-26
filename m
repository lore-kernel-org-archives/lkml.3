Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3FZVK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:10:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46373 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab3FZVK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:10:56 -0400
Date: Wed, 26 Jun 2013 23:10:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86/mce: Update MCE severity condition check
Message-ID: <20130626211052.GN20274@pd.tnic>
References: <20130626091808.GA18468@gchen.bj.intel.com>
 <0134840@agluck-desk.sc.intel.com>
 <20130626190845.GK20274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C5653E@ORSMSX106.amr.corp.intel.com>
 <20130626203639.GM20274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C56603@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C56603@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:00:10PM +0000, Luck, Tony wrote:
> > And this obviously is the case for the hardware too, I assume, not only
> > the SDM?
> 
> Yes - we have a magic process which reconfigures all deployed silicon whenever
> a new SDM is published :-)

Haha, I wouldn't wonder if your silicon dudes come up with
reprogrammable fuses someday :-)

> Actually the SDM had been collecting new features for each generation ... each
> time just bolting on a new paragraph or table.  I snapped when I saw the table
> that was proposed for 15-20 to add "continuable" errors and complained that
> it had gotten way too complicated ... and proposed the version that you see in
> the current SDM.
> 
> It accurately portrays what older generations implemented, and adds the new
> continuable (EIPV=1, RIPV=1) while removing many rows and columns.

Cool :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
