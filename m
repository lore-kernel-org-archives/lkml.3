Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbaIEJrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:47:00 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59290 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756061AbaIEJp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:45:57 -0400
Message-ID: <1409910355.5546.157.camel@x220>
Subject: Re: [PATCH 18/28] Remove MN10300_PROC_MN2WS0038
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 11:45:55 +0200
In-Reply-To: <1403084538.1984.76.camel@x220>
References: <1391971686-9517-19-git-send-email-richard@nod.at>
	 <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1098.1392044308@warthog.procyon.org.uk> <1397553194.1985.23.camel@x220>
	 <1403084538.1984.76.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Sep 2014 09:45:55.0283 (UTC) FILETIME=[30297A30:01CFC8EE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Wed, 2014-06-18 at 11:42 +0200, Paul Bolle wrote:
> On Tue, 2014-04-15 at 11:13 +0200, Paul Bolle wrote:
> > On Mon, 2014-02-10 at 14:58 +0000, David Howells wrote:
> > > Richard Weinberger <richard@nod.at> wrote:
> > > 
> > > > The symbol is an orphan, get rid of it.
> > > > 
> > > > Signed-off-by: Richard Weinberger <richard@nod.at>
> > > 
> > > Acked-by: David Howells <dhowells@redhat.com>
> > 
> > I don't think this oneliner is queued somewhere. David, you're listed as
> > one of the mn10300 maintainers: could you perhaps queue this patch?
> 
> This one is still not part of v3.16-rc1 nor part of linux-next. Is it
> actually queued somewhere?

No surprises here: not part of v3.17-rc3 nor next-20140904. Do you have
suggestions for an alternative route?


Paul Bolle

