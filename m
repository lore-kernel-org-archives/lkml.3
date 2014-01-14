Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaANWDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:03:20 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64684 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751367AbaANWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:03:18 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, l@dorileo.org
Subject: Re: [PATCH V2] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Date: Tue, 14 Jan 2014 23:17:16 +0100
Message-ID: <4100200.O09E65sAKi@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140114212406.GA25438@srcf.ucam.org>
References: <1389019837-13619-1-git-send-email-tianyu.lan@intel.com> <5255063.SeYbBZqxVQ@vostro.rjw.lan> <20140114212406.GA25438@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 14, 2014 09:24:06 PM Matthew Garrett wrote:
> On Tue, Jan 14, 2014 at 10:37:02PM +0100, Rafael J. Wysocki wrote:
> > On Tuesday, January 14, 2014 04:06:01 PM Matthew Garrett wrote:
> > > On Mon, Jan 06, 2014 at 11:25:53PM +0100, Rafael J. Wysocki wrote:
> > > 
> > > > Queued up as a fix for 3.13 (I fixed up the indentation).
> > > 
> > > Ah, sorry, I missed this chunk of the thread. If the system provides 
> > > valid _BIF data then we should possibly just fall back to that rather 
> > > than adding another quirk table.
> > 
> > The problem is to know that _BIX is broken.  If we could figure that out
> > upfront, we woulnd't need the quirk table in any case.
> 
> It's obvious that it is in this case - the package is the wrong size.

Then Tianyu should be able to come up with a better fix relatively easily. :-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
