Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683AbaJ2W2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:28:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaJ2W2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:28:39 -0400
Date: Wed, 29 Oct 2014 15:27:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141029222729.GB8129@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 03:15:51PM -0700, Andy Lutomirski wrote:
> (reply 1/2 -- I'm replying twice to keep the threading sane)
> 
> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > the the protocol layer with the existing userspace D-Bus daemon while
> > enabling some features that couldn't be implemented before in userspace.
> >
> 
> >  * Support for multiple domains, completely separated from each other,
> >    allowing multiple virtualized instances to be used at the same time.
> 
> Given that there is no such thing as a device namespace, how does this work?

See the document for the details.

> The docs seem a bit confusing to me as to whether there's a hierarchy
> of domains.  Do domains have a concept of a parent?

Yes.

> What's "container-name"?

Is that used in the documentation?

> Given that domains have random IDs, how can they be checkpointed and restored?

Good question, I don't know about checkpoint/restore, but I think that
has been done.  Daniel would know more than I do about that.

thanks,

greg k-h
