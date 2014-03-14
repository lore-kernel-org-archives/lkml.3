Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaCNI0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:26:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57480 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497AbaCNI0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:26:22 -0400
Date: Fri, 14 Mar 2014 08:26:15 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: Linn Crosetto <linn@hp.com>, WANG Chao <chaowang@redhat.com>,
        kexec@lists.infradead.org, horms@verge.net.au, ebiederm@xmission.com,
        hpa@zytor.com, trenn@suse.de, vgoyal@redhat.com, bp@alien8.de,
        toshi.kani@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86: Pass memory range via E820 for kdump
Message-ID: <20140314082615.GE5834@console-pimps.org>
References: <1394464149-30384-1-git-send-email-chaowang@redhat.com>
 <1394464149-30384-5-git-send-email-chaowang@redhat.com>
 <20140313222428.GW7672@oranje.fc.hp.com>
 <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar, at 10:47:26AM, Dave Young wrote:
> 
> Can you test with matt's tree to see if it works?
> If it still happens please post the full log.

So that'd be the 'next' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

which contains Borislav's fixes for the EFI memmap code.

-- 
Matt Fleming, Intel Open Source Technology Center
