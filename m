Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaBZNnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:43:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:32229 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaBZNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:43:07 -0500
Date: Wed, 26 Feb 2014 08:43:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
Message-ID: <20140226084304.2c20b0ad@gandalf.local.home>
In-Reply-To: <87ha7mm757.wl%satoru.takeuchi@gmail.com>
References: <8738jatylb.wl%satoru.takeuchi@gmail.com>
	<20140224093039.6509b6cd@gandalf.local.home>
	<530D4F9E.70704@jp.fujitsu.com>
	<87ha7mm757.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 20:43:16 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> >  -# Use SIGILL to terminate virsh console. We can't kill virsh console
> > +# Use SIGKILL to terminate virsh console. We can't kill virsh console
> 
> Oops, it's a completely the different signal. Thanks Takahiro.

Please be careful...
That one letter is the difference between the "Beastie Boys" and "007"

Sending the Beastie Boys out to serve for Her Majesty's Secret Service
would be a disaster.

http://en.wikipedia.org/wiki/Licensed_to_Ill
http://en.wikipedia.org/wiki/Licensed_to_Kill_(1965_film)

-- Steve
