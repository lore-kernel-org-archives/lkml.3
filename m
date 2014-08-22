Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaHVTJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:09:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24542 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaHVTJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:09:53 -0400
Date: Fri, 22 Aug 2014 12:09:27 -0700
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V0 PATCH 1/2] AMD-PVH: set EFER.NX and EFER.SCE
 for the boot vcpu
Message-ID: <20140822120927.03752bc6@mantra.us.oracle.com>
In-Reply-To: <20140822044140.GB11381@nazgul.tnic>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
	<1408587400-18663-2-git-send-email-mukesh.rathor@oracle.com>
	<20140822013904.GA20329@laptop.dumpdata.com>
	<20140821194656.4eea5654@mantra.us.oracle.com>
	<20140822044140.GB11381@nazgul.tnic>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 06:41:40 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Aug 21, 2014 at 07:46:56PM -0700, Mukesh Rathor wrote:
> > Intel doesn't have EFER.NX bit.
> 
> Of course it does.
> 

Right, it does. Some code/comment is misleading... Anyways, reading
intel SDMs, if I understand the convoluted text correctly, EFER.NX is
not required to be set for l1.nx to be set, thus allowing for page
level protection. Where as on AMD, EFER.NX must be set for l1.nx to
be used. So, in the end, this patch would apply to both amd/intel.... 

I'll reword and submit.

Thanks,
Mukesh

