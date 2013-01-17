Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab3AQWwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:52:22 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:44747 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3AQWwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:52:19 -0500
MIME-Version: 1.0
In-Reply-To: <50F87BCA.10201@redhat.com>
References: <1358385543.7040.54.camel@host028-server-9.lan.domdv.de>
 <1358456179.18551.34.camel@haakon2.linux-iscsi.org> <50F87BCA.10201@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jan 2013 14:51:58 -0800
X-Google-Sender-Auth: 0XEyEe8S7yVRG35701Tju5sr-Mc
Message-ID: <CA+55aFx98iAP03VHL9S8UaiYhcdhv=aHcq+i+G43dDmfM8bkJg@mail.gmail.com>
Subject: Re: LIO - the broken iSCSI target implementation
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andreas Steinmetz <ast@domdv.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        target-devel <target-devel@vger.kernel.org>,
        Ritesh Raj Sarraf <rrs@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 2:31 PM, Andy Grover <agrover@redhat.com> wrote:
>
> No... actually upstream targetcli/rtslib are not very well maintained.
> Around 5 patches each in the last year.
>
> Meanwhile, I have been actively maintaining branches at
> github.com/agrover/targetcli-fb and github.com/agrover/rtslib-fb. We
> have a man page and screencasts even. Feel free to file bugs against
> them and I'll respond.

If you look at the linux-iscsi.org link that Nicholas pointed at, it
actually does point to your targetcli-fb as the source package.

The fact that that Andreas then had a hard time finding documentation
and where to report problems, and things didn't work well for him is
obviously a problem, though.

And yes, he may have found the RTS repository because he followed the
Debian entry on linux-iscsi points not to your git tree, but to that
one, but hey, that's Debian. I sometimes suspect that they actively
search out the oldest possible source repository in their quest to be
"stable".

                   Linus
