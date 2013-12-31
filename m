Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3LaWlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 17:41:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45487 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab3LaWlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 17:41:05 -0500
Message-ID: <52C347F0.8070902@zytor.com>
Date: Tue, 31 Dec 2013 14:40:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: halfdog <me@halfdog.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Sanitize CPU-state when switching from virtual-8086 mode to other
 task
References: <52BF4A80.3010503@halfdog.net> <52BF8AEE.6020904@zytor.com> <52C089AC.4000401@halfdog.net> <52C0C9F4.50101@zytor.com> <52C196C3.1040300@halfdog.net> <52C31027.2030101@zytor.com> <20131231192106.GA22535@phenom.dumpdata.com>
In-Reply-To: <20131231192106.GA22535@phenom.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 11:21 AM, Konrad Rzeszutek Wilk wrote:
> 
> So, I am wondering if this is related to " x86/fpu: CR0.TS should be set before trap
> into PV guest's #NM exception handle" which does have a similar pattern - you
> do enough of the task switches and the FPU is screwed.
> 
> See http://mid.gmane.org/1383720072-6242-1-git-send-email-gaoyang.zyh@taobao.com
> 
> (I thought there was a thread about this on LKML too but I can't
> find it).

That would be a bug in Xen, so I guess you're surmising a similar bug in
VirtualBox?

	-hpa


