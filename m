Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaF0LV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:21:58 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44869 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753403AbaF0LV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:21:56 -0400
Date: Fri, 27 Jun 2014 12:21:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
Cc: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Oops: 17 SMP ARM (v3.16-rc2)
Message-ID: <20140627112151.GF32514@n2100.arm.linux.org.uk>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int> <20140626140115.GQ32514@n2100.arm.linux.org.uk> <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int> <20140626151424.GT32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626151424.GT32514@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 04:14:24PM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 26, 2014 at 02:44:52PM +0000, Mattis Lorentzon wrote:
> > We have managed to trigger the Oops by just transferring a large file
> > over nfs
> > cat /mnt/foo > /dev/null
> > where foo is a file that is approximately 2 GB. There may be some
> > packet losses on this network, perhaps this differs from your workload?
> 
> That's a similar workload to the one which is mentioned in the previous
> report.  I've just set a similar transfer going, but this will be a 16GB
> file.

I've run this transfer several times, but so far I've unable to reproduce
the issue here.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
