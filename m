Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaCNU1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:27:25 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:41074 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbaCNU1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:27:24 -0400
Date: Fri, 14 Mar 2014 14:27:06 -0600
From: Linn Crosetto <linn@hp.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Young <dyoung@redhat.com>, WANG Chao <chaowang@redhat.com>,
        kexec@lists.infradead.org, horms@verge.net.au, ebiederm@xmission.com,
        hpa@zytor.com, trenn@suse.de, vgoyal@redhat.com, bp@alien8.de,
        toshi.kani@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86: Pass memory range via E820 for kdump
Message-ID: <20140314202706.GX7672@oranje.fc.hp.com>
References: <1394464149-30384-1-git-send-email-chaowang@redhat.com>
 <1394464149-30384-5-git-send-email-chaowang@redhat.com>
 <20140313222428.GW7672@oranje.fc.hp.com>
 <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
 <20140314082615.GE5834@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314082615.GE5834@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 08:26:15AM +0000, Matt Fleming wrote:
> On Fri, 14 Mar, at 10:47:26AM, Dave Young wrote:
> > 
> > Can you test with matt's tree to see if it works?
> > If it still happens please post the full log.
> 
> So that'd be the 'next' branch at,
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> which contains Borislav's fixes for the EFI memmap code.

I believe I included those fixes when testing with 3.14 rc6, adding:

https://lkml.org/lkml/2014/3/8/209
92b71d8
52d201e
a52f515
b660133
e91925d

Since this testing was done on a prototype, I will send you the log in a
separate email. I tried efi.git/next (with the addition of 4ce7a86), and hit the
same panic.

