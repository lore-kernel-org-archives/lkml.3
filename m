Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaFTO5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:57:19 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:38380
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaFTO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:57:18 -0400
Date: Fri, 20 Jun 2014 16:57:16 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140620145716.GA28243@mail.hallyn.com>
References: <20140618084046.1bce12cc@canb.auug.org.au>
 <1446656.4HCLD295vV@sifl>
 <20140620010837.692e5472@canb.auug.org.au>
 <3494783.s5KPIUO972@sifl>
 <20140620085931.6427678d@canb.auug.org.au>
 <20140620034356.GB20601@mail.hallyn.com>
 <20140620135912.48ee1dff@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620135912.48ee1dff@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (sfr@canb.auug.org.au):
> Hi Serge,
> 
> On Fri, 20 Jun 2014 05:43:56 +0200 "Serge E. Hallyn" <serge@hallyn.com> wrote:
> >
> > The duplicates were the result of several misunderstandings and general
> > naivity all on my part.  I'm actually still not clear on what usually
> > happens with the selinux tree - it feeds into linux-next, then gets
> > 'pull'ed by James into security-next for a pull request?  Do you usually
> > send a request to James when ready, he pulls, then he sends pull request
> > to Linus?  (Or am I wrong, and you usually send your own requests to
> > Linus?)
> 
> If "you" is Paul, then I am pretty sure he asks James to pull and then
> James in turn asks Linus to pull.
> 
> If "you" is me, then no :-)

Thanks :)

-serge
