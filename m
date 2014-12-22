Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaLVQMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 11:12:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60233 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaLVQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 11:12:17 -0500
Date: Mon, 22 Dec 2014 16:12:14 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: System automatically wakes up because of Intel Rapid Start
 Technology
Message-ID: <20141222161214.GA13110@srcf.ucam.org>
References: <9927036.n7iZq92iLW@xps13>
 <20141222145949.GB11844@srcf.ucam.org>
 <3318216.XHaCQKkcW4@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3318216.XHaCQKkcW4@xps13>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 04:50:37PM +0100, Gabriele Mazzotta wrote:
> On Monday 22 December 2014 14:59:49 Matthew Garrett wrote:
> > Can you try this diff?
> 
> Unfortunately it doesn't work (I made a change, see here below).

Ok. Can you hack the resume path to dump the RTC registers on resume? I 
wonder if there's actually a separate set of EFI clock registers. That 
would be irritating.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
