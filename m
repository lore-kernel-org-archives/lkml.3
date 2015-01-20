Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbbATMwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:52:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961AbbATMwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:52:19 -0500
Date: Tue, 20 Jan 2015 06:52:15 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: support for repatching a function
Message-ID: <20150120125215.GC15916@treble.redhat.com>
References: <b211111ad4f29886a44871dddc313a542c48960b.1420834026.git.jpoimboe@redhat.com>
 <alpine.LNX.2.00.1501201051330.31639@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501201051330.31639@pobox.suse.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:56:33AM +0100, Miroslav Benes wrote:
> On Fri, 9 Jan 2015, Josh Poimboeuf wrote:
> > +struct klp_ops {
> > +	struct list_head node;
> > +	struct list_head func_stack;
> > +	struct ftrace_ops fops;
> > +};
> 
> I think it would be useful to add some comments for this structure and its 
> members (similar to the last paragraph of the changelog above). Maybe it 
> is useless now but the code is going to get complicated and it costs 
> nothing...

Ok, thanks.

> Otherwise it looks ok to me (except for thing mentioned by Jiri).
> 
> Thank you
> 
> --
> Miroslav Benes
> SUSE Labs

-- 
Josh
