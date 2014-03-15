Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbaCOOtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:49:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48454 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbaCOOtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:49:04 -0400
Date: Sat, 15 Mar 2014 14:48:55 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linn Crosetto <linn@hp.com>, Dave Young <dyoung@redhat.com>,
        WANG Chao <chaowang@redhat.com>, kexec@lists.infradead.org,
        horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com,
        trenn@suse.de, vgoyal@redhat.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86: Pass memory range via E820 for kdump
Message-ID: <20140315144855.GG5834@console-pimps.org>
References: <1394464149-30384-1-git-send-email-chaowang@redhat.com>
 <1394464149-30384-5-git-send-email-chaowang@redhat.com>
 <20140313222428.GW7672@oranje.fc.hp.com>
 <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
 <20140314082615.GE5834@console-pimps.org>
 <20140314202706.GX7672@oranje.fc.hp.com>
 <20140315142625.GA8735@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140315142625.GA8735@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Mar, at 03:26:25PM, Borislav Petkov wrote:
> 
> Btw, Matt, your whole efi/next stuff is already in tip, right? Because
> if so, Linn could simply test latest tip/master.

Yep, everything is in tip/master.

-- 
Matt Fleming, Intel Open Source Technology Center
