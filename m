Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbbA0KuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:50:00 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53458 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbbA0Kt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:49:58 -0500
Message-ID: <1422355793.14015.45.camel@x220>
Subject: Re: [PATCH] mn10300: remove redundant hex()
From: Paul Bolle <pebolle@tiscali.nl>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 11:49:53 +0100
In-Reply-To: <CAJFMrCE8S6oUqYoWHpKoU-T3ukquU3wUnStdVEdt+J4ytQZe9g@mail.gmail.com>
References: <1417345161-18548-1-git-send-email-arjun024@gmail.com>
	 <CAJFMrCE8S6oUqYoWHpKoU-T3ukquU3wUnStdVEdt+J4ytQZe9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2015 10:49:53.0837 (UTC) FILETIME=[FB9A55D0:01D03A1E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjun,

On Mon, 2015-01-26 at 22:49 +0530, Arjun Sreedharan wrote:
> Ping !!

I wouldn't hold my breath waiting for any response, if I were you.

> On 30 November 2014 at 16:29, Arjun Sreedharan <arjun024@gmail.com> wrote:
> > replace rendundant hex() with kernel's hex_to_bin()
> >
> > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> > ---
> >  arch/mn10300/kernel/gdb-stub.c | 61 ++++++++++++++++--------------------------
> >  1 file changed, 23 insertions(+), 38 deletions(-)

You can't actually build a mn10300 kernel with GDBSTUB set since
v2.6.39, see https://lkml.org/lkml/2014/9/18/387 . Perhaps you still
managed to build arch/mn10300/kernel/gdb-stub.o manually, bypassing
kconfig. Or did you just edit out its dependency on DEPRECATED?


Paul Bolle

