Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3IWO7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:59:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3IWO73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:59:29 -0400
Date: Mon, 23 Sep 2013 17:59:25 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 0/3] KVM: Make kvm_lock non-raw
Message-ID: <20130923145925.GA10353@redhat.com>
References: <1379340373-5135-1-git-send-email-pbonzini@redhat.com>
 <20130922074238.GG25202@redhat.com>
 <523EAFFA.6060203@redhat.com>
 <20130922095348.GJ25202@redhat.com>
 <524043C5.70700@windriver.com>
 <524045B5.5020308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524045B5.5020308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 03:44:21PM +0200, Paolo Bonzini wrote:
> Il 23/09/2013 15:36, Paul Gortmaker ha scritto:
> >> > The change is not completely trivial, it splits lock. There is no
> >> > obvious problem of course, otherwise you wouldn't send it and I
> >> > would ack it :), but it does not mean that the chance for problem is
> >> > zero, so why risk stability of stable even a little bit if the patch
> >> > does not fix anything in stable?
> >> > 
> >> > I do not know how -rt development goes and how it affects decisions for
> >> > stable acceptance, why can't they carry the patch in their tree until
> >> > they move to 3.12?
> > The -rt tree regularly carries mainline backports that are of interest
> > to -rt but perhaps not of interest to stable, so there is no problem
> > doing the same with content like this, if desired.
> 
> Perfect, I'll queue [v2 of] these patches for 3.12 then.
> 
Why 3.12 if it is not going to stable?

--
			Gleb.
