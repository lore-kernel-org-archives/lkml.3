Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3H1W6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 18:58:16 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:40718 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3H1W6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 18:58:15 -0400
Date: Wed, 28 Aug 2013 18:58:12 -0400 (EDT)
From: Lenny Szubowicz <lszubowi@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
Message-ID: <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
In-Reply-To: <1377729714.27493.2.camel@x230>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com> <1241952070.8587861.1377729463830.JavaMail.root@redhat.com> <1377729714.27493.2.camel@x230>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF17 (Linux)/8.0.3_GA_5664)
Thread-Topic: [PATCH 0/10] Add additional security checks when module
 loading is restricted
Thread-Index: Nz5hbGPlr11vDxoZBtCj48/bXxVZzqCFps4AWFn4cQE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Matthew Garrett" <matthew.garrett@nebula.com>
> To: "Lenny Szubowicz" <lszubowi@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
> Sent: Wednesday, August 28, 2013 6:41:55 PM
> Subject: Re: [PATCH 0/10] Add additional security checks when module loading is restricted
> 
> On Wed, 2013-08-28 at 18:37 -0400, Lenny Szubowicz wrote:
> 
> > Did you purposely exclude similar checks for hibernate that were covered
> > by earlier versions of your patch set?
> 
> Yes, I think it's worth tying it in with the encrypted hibernation
> support. The local attack is significantly harder in the hibernation
> case - in the face of unknown hardware it basically involves a
> pre-generated memory image corresponding to your system or the ability
> to force a reboot into an untrusted environment. I think it's probably
> more workable to just add a configuration option for forcing encrypted
> hibernation when secure boot is in use.
> 
> --
> Matthew Garrett <matthew.garrett@nebula.com>

I'm root. So I can write anything I want to the swap file that looks
like a valid hibernate image but is code of my choosing. I can read
anything I need from /dev/mem or /dev/kmem to help me do that.
I can then immediately initiate a reboot.

                               -Lenny.
