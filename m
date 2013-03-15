Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3COUn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:43:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58483 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932313Ab3COUnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:43:25 -0400
Message-ID: <1363380204.2433.12.camel@joe-AO722>
Subject: Re: [PATCH] cifs: Rename cERROR and cFYI to cifs_dbg
From: Joe Perches <joe@perches.com>
To: Steve French <smfrench@gmail.com>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 15 Mar 2013 13:43:24 -0700
In-Reply-To: <CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ@mail.gmail.com>
References: <1363128287.23052.21.camel@joe-AO722>
	 <1363174614.2031.9.camel@joe-AO722>
	 <20130313075155.7464a34a@tlielax.poochiereds.net>
	 <1363178421.2031.29.camel@joe-AO722> <1363289077.2146.19.camel@joe-AO722>
	 <20130315150136.7f7a262a@tlielax.poochiereds.net>
	 <CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 15:16 -0500, Steve French wrote:

> I would like to merge the three we have (one still has to be put in
> for-next - the one from Jeff) for for-next in the next three or fouir
> days - but I can create another temporary branch for the ones for 3.10
> - but ... I would like to simplify things by merging the other cleanup
> patches we already have first.  I agree that we are going to have to
> let people know to rebase everything for cifs for 3.10 on this big
> cleanup patch.

Another possibility is to extend the
cifs_dbg(type, fmt. ...) types from

VFS, FYI, NOISY

so that the messages could be
filtered/classified better.

Also, perhaps it'd be better to use
pr_debug instead of KERN_ERR for
the VFS messages.


