Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3IFBv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:51:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3IFBvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:51:55 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BbXNHQx3NekA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fxhqf5xVK60A:10 a=20KFwNOVAAAA:8 a=VG2FNCXc219QzkaJD1YA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 5 Sep 2013 21:51:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace 'failed to modify' bug when loading reiserfs.ko
Message-ID: <20130905215154.74c55e9a@gandalf.local.home>
In-Reply-To: <20130906014859.GB10073@redhat.com>
References: <20130906011924.GA7970@redhat.com>
	<20130905212834.605408a4@gandalf.local.home>
	<20130906013455.GA10073@redhat.com>
	<20130905214455.101c6347@gandalf.local.home>
	<20130906014859.GB10073@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013 21:48:59 -0400
Dave Jones <davej@redhat.com> wrote:

> On Thu, Sep 05, 2013 at 09:44:55PM -0400, Steven Rostedt wrote:
>  > On Thu, 5 Sep 2013 21:34:55 -0400
>  > Dave Jones <davej@redhat.com> wrote:
>  > 
>  > > On Thu, Sep 05, 2013 at 09:28:34PM -0400, Steven Rostedt wrote:

>  > Did you change a config option, or update your gcc?
> 
> Yeah, changed CONFIG_DEBUG_KOBJECT, which rebuilt the world.

Still doesn't explain why it gave you that splat there.

Do you still have that binary module, and can you show me what's at
reiserfs_init_bitmap_cache+0x0 with objdump?

-- Steve
