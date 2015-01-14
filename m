Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbbANR5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:57:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbbANR5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:57:09 -0500
Date: Wed, 14 Jan 2015 18:56:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
	userspace
Message-ID: <20150114175608.GA15392@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113171134.GA27519@redhat.com> <54B55BE7.1020107@redhat.com> <20150113182239.GA30475@redhat.com> <20150113183003.GB30475@redhat.com> <54B57AAC.6020903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B57AAC.6020903@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13, Rik van Riel wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 01/13/2015 01:30 PM, Oleg Nesterov wrote:
> > On 01/13, Oleg Nesterov wrote:
> >>
> >> But yes, I think we need the per-cpu "in_kernel_fpu" and
> >> irq_fpu_usable() must die. Please look at
> >> http://marc.info/?l=linux-kernel&m=14096628660929
>
> This link does not work for me. I wonder if that email is not
> on the marc.info node I managed to send my http request to...

Sorry, copy-and-paste error,
http://marc.info/?l=linux-kernel&m=140966286609295

> > Plus I think we need this to fix the race with
> > math_state_restore()... Please see
> > http://marc.info/?l=linux-kernel&m=140992479607206
> >
> > Unfortunately I forgot other problems I found in this area... And I
> > completely forgot the plan I had in mind ;)
>
> That I can certainly merge into my series.

Perhaps I should resend this series... I'll recheck, it should not
conflict with your changes (at least too much).

Oleg.

