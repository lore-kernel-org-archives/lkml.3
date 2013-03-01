Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3CAAgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:36:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59619 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3CAAgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:36:39 -0500
Date: Fri, 1 Mar 2013 01:36:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, rostedt@goodmis.org,
        gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] mm/x86: Patch out arch_flush_lazy_mmu_mode() when
 running on bare metal
Message-ID: <20130301003629.GG9767@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
	tglx@linutronix.de, konrad.wilk@oracle.com, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, samu.kallio@aberdeencloud.com,
	kraman@redhat.com, xen-devel@lists.xen.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
References: <1362092149-32381-1-git-send-email-boris.ostrovsky@oracle.com>
 <20130228233720.GB17468@pd.tnic>
 <20130301000539.GA31649@hansolo.jdub.homelinux.org>
 <512FF331.5050008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512FF331.5050008@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:15:45PM -0800, H. Peter Anvin wrote:
> > I'll try to get someone to test this tomorrow.

Btw, you'd need to apply that other patch too

http://marc.info/?l=xen-devel&m=136206183814547&w=2

so that arch_flush_lazy_mmu_mode() has at least one caller on x86_64.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
