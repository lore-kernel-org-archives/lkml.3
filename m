Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbaKZPYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:24:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:53196 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750961AbaKZPXy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:23:54 -0500
Date: Wed, 26 Nov 2014 10:23:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Paolo Bonzini <pbonzini@redhat.com>,
        nick <xerofoify@gmail.com>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
Message-ID: <20141126102346.213ee325@gandalf.local.home>
In-Reply-To: <20141126144933.GA5630@potion.brq.redhat.com>
References: <5472B5B5.5090201@gmail.com>
	<54730475.9040000@redhat.com>
	<54730B33.1080101@siemens.com>
	<20141124210000.GB6795@potion.brq.redhat.com>
	<20141124161901.6266925c@gandalf.local.home>
	<20141124214939.GA6671@potion.brq.redhat.com>
	<20141126124022.GC6795@potion.brq.redhat.com>
	<20141126091543.52dc5bfe@gandalf.local.home>
	<20141126144933.GA5630@potion.brq.redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 15:49:34 +0100
Radim Krčmář <rkrcmar@redhat.com> wrote:

 
> (It just seemed weird that we have an infrastructure that could allow a
>  "generic plugin" to cover this functionality.)

Maybe in the future we may do something like that. But for now, think
of these as "optimized" ;-)

-- Steve
