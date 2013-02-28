Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3B1QLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:11:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38178 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab3B1QLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:11:06 -0500
Date: Thu, 28 Feb 2013 17:10:57 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Re: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was:
 Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Message-ID: <20130228161057.GC9767@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
	tglx@linutronix.de, xen-devel@lists.xen.org,
	linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
	kraman@redhat.com, jwboyer@redhat.com
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default>
 <512E8B41.8000504@zytor.com>
 <20130227230009.GA32465@kroah.com>
 <512E91B7.6060102@zytor.com>
 <20130228142910.GA32354@phenom.dumpdata.com>
 <20130228153846.GA9782@pd.tnic>
 <512F7D88.4090703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512F7D88.4090703@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 07:53:44AM -0800, H. Peter Anvin wrote:
> At the very least we should have an early filter for the **COMMON!**
> case that we are not on a PV platform.

... or, patch it out with the alternatives on baremetal, as Steven
suggested.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
