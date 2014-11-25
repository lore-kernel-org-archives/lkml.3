Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKYXUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:20:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38680 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751061AbaKYXUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:20:53 -0500
Date: Tue, 25 Nov 2014 18:20:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: jslaby@suse.cz, Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>, nsekhar@ti.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mingo@redhat.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm: ftrace: Adds support for ftrace operations
Message-ID: <20141125182038.04497ec0@gandalf.local.home>
In-Reply-To: <CACh+v5MDFZj+NOPWdnMgNthn_DxL3nn=CZJ224vMh7hSf84o4Q@mail.gmail.com>
References: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
	<20141107115225.72bc6cbf@gandalf.local.home>
	<545CFAF4.8030104@traphandler.com>
	<CACh+v5MDFZj+NOPWdnMgNthn_DxL3nn=CZJ224vMh7hSf84o4Q@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2014 10:59:24 +0100
Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:

> Hi Steve,
> did you get a chance of running your tests suite on real hardware with
> this patch? I'd be really interested in the results.

Yes I finally got it working on my beaglebone white. It passed all the
tests that passed without it. Although I'm not sure this patch itself
was tested as I didn't have kprobes which might use it.

-- Steve
