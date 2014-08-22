Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaHVEln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:41:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47999 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbaHVElm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:41:42 -0400
Date: Fri, 22 Aug 2014 06:41:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V0 PATCH 1/2] AMD-PVH: set EFER.NX and EFER.SCE for
 the boot vcpu
Message-ID: <20140822044140.GB11381@nazgul.tnic>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
 <1408587400-18663-2-git-send-email-mukesh.rathor@oracle.com>
 <20140822013904.GA20329@laptop.dumpdata.com>
 <20140821194656.4eea5654@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140821194656.4eea5654@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 07:46:56PM -0700, Mukesh Rathor wrote:
> Intel doesn't have EFER.NX bit.

Of course it does.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
