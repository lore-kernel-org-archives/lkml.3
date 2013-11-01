Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3KABPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 21:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab3KABPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 21:15:48 -0400
Date: Fri, 1 Nov 2013 09:15:04 +0800
From: Dave Young <dyoung@redhat.com>
To: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.fedoraproject.org, kexec@lists.infradead.org,
        corbet@lwn.net
Subject: Re: [patch 3/6] Cleanup efi_enter_virtual_mode function
Message-ID: <20131101011503.GA4378@dhcp-16-126.nay.redhat.com>
References: <20131028145801.GM4314@pd.tnic>
 <20131028151048.GA14984@dhcp-16-126.nay.redhat.com>
 <20131029023203.GB5185@dhcp-16-126.nay.redhat.com>
 <20131029134302.GI10972@pd.tnic>
 <20131030020348.GA4332@dhcp-16-126.nay.redhat.com>
 <20131030104718.GB13290@pd.tnic>
 <20131031020405.GA4377@dhcp-16-126.nay.redhat.com>
 <20131031020714.GB4377@dhcp-16-126.nay.redhat.com>
 <5271C981.2050705@zytor.com>
 <20131031104535.GB10544@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031104535.GB10544@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/13 at 11:45am, Borislav Petkov wrote:
> On Wed, Oct 30, 2013 at 08:07:45PM -0700, H. Peter Anvin wrote:
> > You can use git for your own purposes, still.
> 
> git mk-coffee --refill --now

Ccing Jonathan Corbet ;)
