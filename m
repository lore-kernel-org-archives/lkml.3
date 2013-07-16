Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab3GPTuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:50:05 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:42932
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932991Ab3GPTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:50:04 -0400
Date: Tue, 16 Jul 2013 19:50:03 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] allow some kernel filesystems to be mounted in a
 user namespace
Message-ID: <20130716195002.GA23370@mail.hallyn.com>
References: <20130716192920.GA8980@sergelap>
 <20130716193826.GP4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716193826.GP4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Al Viro (viro@ZenIV.linux.org.uk):
> On Tue, Jul 16, 2013 at 02:29:20PM -0500, Serge Hallyn wrote:
> > All the files will be owned by host root, so there's no security
> > concern in allowing this.
> 
> Files owned by root != very bad things can't be done by non-root.
> Especially for debugfs, which is very much a "don't even think about
> mounting that on a production box" thing...

I would prefer it not be mounted.  But near as I can tell there
should be no regression security-wise whether an unprivileged
user on the host has access to it, or whether a user in a
non-init user ns is allowed to mount it.  (Obviously I could very
well be wrong)

-serge
