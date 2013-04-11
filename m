Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3DKP57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:57:59 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:65317 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3DKP56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:57:58 -0400
Date: Thu, 11 Apr 2013 08:57:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
Message-ID: <20130411155756.GA24668@kroah.com>
References: <20130406165600.GA29660@kroah.com>
 <87y5cpvhaz.fsf@xmission.com>
 <20130411155606.GA14042@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411155606.GA14042@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:56:06AM -0700, Greg KH wrote:
> > > +		newattrs.ia_uid = uid;
> > > +		newattrs.ia_gid = gid;
> > This doesn't even compile because the types are wrong.
> 
> Yes, this has been fixed.  But note, it only fails the build if
> namespaces are enabled, and given that no one seems to have reported
> this build error in either the 0-day tester, or linux-next, or the
> distro developers that tested this patch on their systems, it seems that
> no one enables namespaces on their systems :(

USER_NS that is, not namespaces in general, sorry about that.

greg k-h
