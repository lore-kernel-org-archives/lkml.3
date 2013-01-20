Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab3ATL57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:57:59 -0500
Received: from 8bytes.org ([85.214.48.195]:40986 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab3ATL56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:57:58 -0500
Date: Sun, 20 Jan 2013 12:57:55 +0100
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>, Udo van den Heuvel <udovdh@xs4all.nl>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130120115755.GO25591@8bytes.org>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130120114828.GB16519@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun Jan 20 12:57:56 2013
X-DSPAM-Confidence: 0.9969
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50fbdbc422972884111305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:48:28PM +0100, Borislav Petkov wrote:
> On Sun, Jan 20, 2013 at 12:40:11PM +0100, Jörg Rödel wrote:
> > Yes, the BIOS vendor can fix this issue. They need to disable NB clock
> > gating for the IOMMU.
> 
> Right, Udo, you can try Gigabyte first.
> 
> Btw, can't we add a quirk to disable NB clock gating? Maybe Boris and
> Jacob could help. CCed.

BorisO is no longer with AMD afaik. I wrote an email to Sherry and
Suravee and asked them to either send me hardware to write the fix on my
own or to send a fix for the issue. Let's see what happens...


	Joerg


