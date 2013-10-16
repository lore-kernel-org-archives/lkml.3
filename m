Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3JPPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:18:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34395 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab3JPPSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:18:42 -0400
Date: Wed, 16 Oct 2013 08:18:31 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <james.l.morris@oracle.com>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
Message-ID: <20131016151831.GE5186@outflux.net>
References: <20130920203556.GA8726@www.outflux.net>
 <alpine.LRH.2.02.1309241124420.3782@tundra.namei.org>
 <alpine.LRH.2.02.1309241128430.3782@tundra.namei.org>
 <CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ9t7tet4Bx=VUaVmjp1C18iK-nLpQBgmXqgukoAmmd4A@mail.gmail.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Mon, Sep 23, 2013 at 06:45:35PM -0700, Kees Cook wrote:
> [+rusty]
> 
> On Mon, Sep 23, 2013 at 6:28 PM, James Morris <jmorris@namei.org> wrote:
> > On Tue, 24 Sep 2013, James Morris wrote:
> >
> >> On Fri, 20 Sep 2013, Kees Cook wrote:
> >>
> >> > This LSM enforces that modules must all come from the same filesystem,
> >> > with the expectation that such a filesystem is backed by a read-only
> >> > device such as dm-verity or CDROM. This allows systems that have a
> >> > verified or unchanging filesystem to enforce module loading restrictions
> >> > without needing to sign the modules individually.
> >> >
> >> > Signed-off-by: Kees Cook <keescook@chromium.org>
> >>
> >> Are you using this for ChromeOS?
> 
> Yes. Chrome OS uses a read-only root filesystem that is backed by
> dm-verity. This lets us pin all module loading to that filesystem
> without needing per-module signatures.
> 
> > Also, you should CC Rusty on this.
> 
> Done! :)

Any update on this? It'd be nice to have it in linux-next.

Thanks,

-Kees

-- 
Kees Cook                                            @outflux.net
