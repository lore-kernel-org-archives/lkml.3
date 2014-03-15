Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaCOOml (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:42:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47628 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaCOOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:42:15 -0400
Date: Sat, 15 Mar 2014 15:41:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linn Crosetto <linn@hp.com>
Cc: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>,
        WANG Chao <chaowang@redhat.com>, kexec@lists.infradead.org,
        horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com,
        trenn@suse.de, vgoyal@redhat.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86: Pass memory range via E820 for kdump
Message-ID: <20140315144157.GC8735@nazgul.tnic>
References: <1394464149-30384-1-git-send-email-chaowang@redhat.com>
 <1394464149-30384-5-git-send-email-chaowang@redhat.com>
 <20140313222428.GW7672@oranje.fc.hp.com>
 <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
 <20140314082615.GE5834@console-pimps.org>
 <20140314202706.GX7672@oranje.fc.hp.com>
 <20140315142625.GA8735@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140315142625.GA8735@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 03:26:25PM +0100, Borislav Petkov wrote:
> Also, please try to catch full dmesg and the whole oops.

Ok, nevermind, I've got your mail with full dmesg in my other mbox; I'll
take a look next week.

Thanks.

