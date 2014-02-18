Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaBRRcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:32:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBRRcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:32:12 -0500
Message-ID: <1392744726.2165.28.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no
 rules
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steve Grubb <sgrubb@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Tue, 18 Feb 2014 12:32:06 -0500
In-Reply-To: <CALCETrXReQ_AT9W4At4VZnyqnaYgTBB3X8-_V=-qJnucGjV2rg@mail.gmail.com>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
	 <CALCETrX9gb_+zW4UZZv5icCQ-3HNG7BFZOaqMPYaQfzotsZpnA@mail.gmail.com>
	 <CALCETrX0GtSaLUB9UBeKsxOoVhiVyMzWrZTYt3O5He1Wdvz+1Q@mail.gmail.com>
	 <6663120.dfAPuuBWIr@x2>
	 <CALCETrXReQ_AT9W4At4VZnyqnaYgTBB3X8-_V=-qJnucGjV2rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 12:04 -0800, Andy Lutomirski wrote:
> On Mon, Feb 10, 2014 at 11:12 AM, Steve Grubb <sgrubb@redhat.com> wrote:

> 2. Do AVC denial messages still get logged if audit_enable == 0?  If
> not, then audit_enable is a non-starter.

They go out printk/dmesg/syslog

