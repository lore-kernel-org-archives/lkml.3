Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbbAFUqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:46:16 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:44254 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbbAFUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:46:13 -0500
Date: Tue, 6 Jan 2015 21:46:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 26/40] arch/sparc: uaccess_64 macro whitespace fixes
Message-ID: <20150106204607.GA22468@ravnborg.org>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-27-git-send-email-mst@redhat.com>
 <20150106165339.GA11270@ravnborg.org>
 <20150106171902.GA11577@redhat.com>
 <20150106182749.GA19490@ravnborg.org>
 <20150106202342.GB12455@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106202342.GB12455@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > sparc64: fix coding style in uaccess_64.h
> 
> OK.
> I see David reviewed and sent acks, so I won't bother
> reposting, but I'll tweak this in my tree.
OK.

> > > I get it you like it that 
> > > 	case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break;
> > > has the whole case on the same line?
> > > Is that the issue?
> > Exactly - much easier to read this way.
> > That the "\" was not aligned in these parts of the code did not help either.
> > 
> > 	Sam
> 
> I see David acked this already - I'll do a patch on top to tweak just
> these two places to your liking?

Thanks.
When you have done so please wait for David's ack before you
sent then upstream. That I like it does not make it universally accepted.

	Sam
