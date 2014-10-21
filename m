Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaJUJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:14:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45034 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaJUJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:14:36 -0400
Date: Tue, 21 Oct 2014 02:13:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Christoph Hellwig <hch@infradead.org>, Pieter Smith <pieter@boesman.nl>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Matt Turner <mattst88@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>,
        ????????? <zhenglong.cai@cs2c.com.cn>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        "open list:ABI/API" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/2] fs: Support compiling out sendfile
Message-ID: <20141021091356.GA26330@infradead.org>
References: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
 <1413841728-1313-2-git-send-email-pieter@boesman.nl>
 <20141020222421.GE8929@cloud>
 <20141021075154.GB10020@infradead.org>
 <20141021090421.GB17604@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021090421.GB17604@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 02:04:22AM -0700, Josh Triplett wrote:
> That's the plan, but since sendfile depends on some of the splice bits,
> sendfile needs to be optional as well; SENDFILE_SYSCALL will then select
> SPLICE_SYSCALLS.

Just include sendfile with the splice syscalls - we don't really need a
config option for every obscure syscall.

