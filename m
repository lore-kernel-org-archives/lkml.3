Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965590AbaFRJmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:42:21 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:53385 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965210AbaFRJmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:42:19 -0400
Message-ID: <1403084538.1984.76.camel@x220>
Subject: Re: [PATCH 18/28] Remove MN10300_PROC_MN2WS0038
From: Paul Bolle <pebolle@tiscali.nl>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Richard Weinberger <richard@nod.at>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 11:42:18 +0200
In-Reply-To: <1397553194.1985.23.camel@x220>
References: <1391971686-9517-19-git-send-email-richard@nod.at>
	 <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1098.1392044308@warthog.procyon.org.uk> <1397553194.1985.23.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 09:42:18.0687 (UTC) FILETIME=[986D4CF0:01CF8AD9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, Koichi,

On Tue, 2014-04-15 at 11:13 +0200, Paul Bolle wrote:
> On Mon, 2014-02-10 at 14:58 +0000, David Howells wrote:
> > Richard Weinberger <richard@nod.at> wrote:
> > 
> > > The symbol is an orphan, get rid of it.
> > > 
> > > Signed-off-by: Richard Weinberger <richard@nod.at>
> > 
> > Acked-by: David Howells <dhowells@redhat.com>
> 
> I don't think this oneliner is queued somewhere. David, you're listed as
> one of the mn10300 maintainers: could you perhaps queue this patch?

This one is still not part of v3.16-rc1 nor part of linux-next. Is it
actually queued somewhere?


Paul Bolle

