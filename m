Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaATQhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:37:07 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34541 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaATQhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:37:04 -0500
Date: Mon, 20 Jan 2014 16:37:01 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Souvik Banerjee <souvik1997@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
Message-ID: <20140120163701.GA6312@srcf.ucam.org>
References: <52DD4096.6020408@gmail.com>
 <20140120153105.GA1650@srcf.ucam.org>
 <52DD492F.1060208@gmail.com>
 <20140120161132.GC3844@srcf.ucam.org>
 <52DD4F74.4000807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DD4F74.4000807@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 10:31:48AM -0600, Souvik Banerjee wrote:
> I used KE_KEY instead of KE_IGNORE. Should it be changed to KE_IGNORE?
> On my kernel build with KE_KEY everything works as expected, but I have
> not tried it with KE_IGNORE.

KE_KEY means that dell-wmi will report the key. If it's also being 
reported via the keyboard controller then it should be KE_IGNORE 
instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
