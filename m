Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaAVUae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:30:34 -0500
Received: from know-smtprelay-omc-8.server.virginmedia.net ([80.0.253.72]:38075
	"EHLO know-smtprelay-omc-8.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbaAVUac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:30:32 -0500
X-Originating-IP: [81.106.150.188]
X-Spam: 0
X-Authority: v=2.1 cv=Rs1LLUWK c=1 sm=1 tr=0 a=DGj713NdaxKrsjjgQne7PA==:117
 a=DGj713NdaxKrsjjgQne7PA==:17 a=LcaDllckn3IA:10 a=uObrxnre4hsA:10
 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=_TlXeT_K3ZwA:10 a=pGLkceISAAAA:8
 a=1XWaLZrsAAAA:8 a=vnrOc9ghOsB5YTOp_nYA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10
Date: Wed, 22 Jan 2014 20:30:30 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Junio C Hamano <gitster@pobox.com>
Cc: Vicent =?iso-8859-1?Q?Mart=ED?= <tanoku@gmail.com>,
        Stefan =?iso-8859-1?Q?N=E4we?= 
	<stefan.naewe@atlas-elektronik.com>,
        Javier Domingo Cansino <javierdo1@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.9-rc0
Message-ID: <20140122203030.GB14211@milliways>
References: <xmqq61pjzljn.fsf@gitster.dls.corp.google.com>
 <xmqqha8xt22p.fsf@gitster.dls.corp.google.com>
 <CALZVapmqcFjjKeURHdP4chkB+T2--caJZYiJBzdwq7Ou=HzO5w@mail.gmail.com>
 <52DFE882.2040605@atlas-elektronik.com>
 <xmqq7g9syp1m.fsf@gitster.dls.corp.google.com>
 <CAFFjANTNLnc4GcVeSEvuWpfYVXJchJqkHwvUVdREdXmWx6e4=Q@mail.gmail.com>
 <xmqqlhy7yjjp.fsf@gitster.dls.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xmqqlhy7yjjp.fsf@gitster.dls.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:10:18AM -0800, Junio C Hamano wrote:
> Vicent Martí <tanoku@gmail.com> writes:
> 
> >> Do these consume CPU every time somebody asks for a tarball?  That
> >> might be considered "wrong" depending on the view.
> >
> > No, our infrastructure caches frequently requested tarballs so they
> > don't have to be regenerated on the fly.
> 
> Thanks.  That is certainly good enough for consumers, and better
> than having to manually create and upload for me ;-)

 Two questions: Does regenerating (e.g. if the tarball has dropped
out of the cache) change its sums (md5sum or similar) ?  In (beyond)
linuxfromscratch we use md5sums to verify that a tarball has not
changed.  Also, will there be links for manpages and htmldocs
tarballs ?

 I note that all of these *are* still available at googlecode for
the moment : https://code.google.com/p/git-core/downloads/list

ĸen
-- 
das eine Mal als Tragödie, dieses Mal als Farce
