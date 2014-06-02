Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbaFBLym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:54:42 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35006 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaFBLyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:54:39 -0400
Message-ID: <1401710072.15098.35.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH v4 4/4] KEYS: define an owner trusted keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jun 2014 07:54:32 -0400
In-Reply-To: <CACE9dm-bqp-a3yogxEDk3M1c-XByuYki+7jZK3=U=VtqDMkCRQ@mail.gmail.com>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1401289784-31340-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <CACE9dm-CwB=wPffdg7UMKWw1LBaePBgxXPYd9E51dZK+kpFKBw@mail.gmail.com>
	 <1401588848.22476.33.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm_9QQapE=NiPF+vL=RpuoVAFLotOyzObcRRZ=+rqeuCOw@mail.gmail.com>
	 <1401708833.15098.26.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm-bqp-a3yogxEDk3M1c-XByuYki+7jZK3=U=VtqDMkCRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060211-7164-0000-0000-00000228328F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 14:40 +0300, Dmitry Kasatkin wrote: 
> On 2 June 2014 14:33, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Mon, 2014-06-02 at 13:48 +0300, Dmitry Kasatkin wrote:

> > Currently only the builtin keys are on the system keyring, but once
> > David and Josh's UEFI patches are upstreamed, the UEFI keys will also be
> > on the system keyring.  At that point, we would want to differentiate
> > between the builtin keys and the remaining keys on the system keyring.
> > Splitting this patch definitely helps clarify what's happening and, more
> > importantly, why.
> >
> > Mimi
> >
> 
> Ok. May be would should focus on patches for existing functionality.
> If something new comes from other side, it can be addressed by new
> another set of patches.

True, making the IMA keyring a trusted keyring is important by itself,
but the real benefit is the ability for the platform owner to create and
use their own key without having to rebuild the kernel.  The platform
owner then controls which keys are to be trusted.

Mimi

