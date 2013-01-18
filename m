Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3ARQfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:35:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51463 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3ARQfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:35:40 -0500
Date: Fri, 18 Jan 2013 16:35:36 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net
Subject: Re: / is remounted when the power cable is plugged in/out
Message-ID: <20130118163536.GB31499@srcf.ucam.org>
References: <50F477F5.8070403@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50F477F5.8070403@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:26:13PM +0100, Toralf Förster wrote:
> b/c of the unknown event 0x6040 the ibm acpi list is Cc'ed, but what makes me really wondering is
> why / is remounted.

Because something in your userspace is changing the filesystem commit 
interval.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
