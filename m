Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbaD2LlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:41:15 -0400
Received: from aa.linuxbox.com ([69.128.83.226]:1942 "EHLO aa.linuxbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbaD2LlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:41:13 -0400
Date: Tue, 29 Apr 2014 07:40:08 -0400 (EDT)
From: "Matt W. Benjamin" <matt@linuxbox.com>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        samba-technical@lists.samba.org, linux-nfs@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <1482413734.4.1398771608019.JavaMail.root@thunderbeast.private.linuxbox.com>
In-Reply-To: <20140429071153.176c7404@tlielax.poochiereds.net>
Subject: Re: OFD ("file private") locks and NFS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.0.10]
X-Mailer: Zimbra 6.0.5_GA_2180.CentOS5_64 (ZimbraWebClient - FF3.0 (Win)/6.0.5_GA_2180.CentOS5_64)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (aa.linuxbox.com [10.1.1.1]); Tue, 29 Apr 2014 07:40:15 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Something which came up on the last Ganesha conn call is that we have
a pretty strong need for some ability to wait on a set of locks, and perhaps
receive events.  Frank Filz believed that you had made a proposal which
would cover this.  Can you elaborate on that?

Thanks,

Matt

----- "Jeff Layton" <jlayton@poochiereds.net> wrote:

> 
> If we really find later that we need to do something like this, I
> think
> we'd be better off adding a new set of cmd values along with the
> "extended" struct, or possibly a new syscall. Some of the samba folks
> were interested in an async locking mechanism too, so something like
> that could be added in conjunction with such an interface.
> 


-- 
Matt Benjamin
The Linux Box
206 South Fifth Ave. Suite 150
Ann Arbor, MI  48104

http://linuxbox.com

tel.  734-761-4689 
fax.  734-769-8938 
cel.  734-216-5309 
