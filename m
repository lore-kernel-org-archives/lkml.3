Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647Ab3JOTLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:11:08 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44580 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3JOTLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:11:05 -0400
Date: Wed, 16 Oct 2013 00:40:40 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: Extended H/W error log driver
Message-ID: <20131015191040.GA4347@naverao1-tp.ibm.com>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <20131011080427.GC18719@pd.tnic>
 <20131014064940.GD12189@gchen.bj.intel.com>
 <20131014105533.GF4009@pd.tnic>
 <20131015040731.GA887@gchen.bj.intel.com>
 <20131015092851.GA7908@pd.tnic>
 <CA+8MBbJeSJBDPcomupOuVBrnZNkMTNTXsoZY9yUbXPe9YrTFXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbJeSJBDPcomupOuVBrnZNkMTNTXsoZY9yUbXPe9YrTFXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101519-0260-0000-0000-000003C950B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/15 09:15AM, Tony Luck wrote:
> On Tue, Oct 15, 2013 at 2:28 AM, Borislav Petkov <bp@alien8.de> wrote:
> > We can even add a hint for the user like:
> >
> >         "Above errors have been corrected by the hardware and require no further action."
> >
> > Btw, this is valid for both dmesg and trace event output.
> >
> > Because from my experience so far people just scream: "Look, I just had
> > an MCE" withot even reading what it says. And this just upsets support
> > people for no valid reason at all.
> 
> "Like", "+1", "metoo" ... or whatever it is we do on LKML to indicate
> we approve.

+2 ;)

While at it, I wonder if we're better off calling these "Hardware
events" rather than "Hardware errors".


Thanks,
Naveen

