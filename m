Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3CWWxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 18:53:19 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:46942 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab3CWWxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 18:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1303231705170.5135@kaball.uk.xensource.com>
References: <20130322210201.GA7932@phenom.dumpdata.com>
	<alpine.DEB.2.02.1303231705170.5135@kaball.uk.xensource.com>
Date: Sat, 23 Mar 2013 15:53:17 -0700
X-Google-Sender-Auth: c3H_xcDL8SshUSxANqAVqnzzuwo
Message-ID: <CA+55aFzou20pkuutNKTgz2yM2MvRomRaJPLRQgoSCySKkgD0BQ@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.9-rc3-tag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 10:08 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>
> Unless I am looking in the wrong place, this patch is still the same one
> that breaks PV on HVM and Xen ARM guests, see:

Konrad?

I'll hold off on the pull request for now.

             Linus
