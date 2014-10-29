Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbaJ2WQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:16:16 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36515 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbaJ2WQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:16:13 -0400
MIME-Version: 1.0
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 15:15:51 -0700
Message-ID: <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(reply 1/2 -- I'm replying twice to keep the threading sane)

On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.
>

>  * Support for multiple domains, completely separated from each other,
>    allowing multiple virtualized instances to be used at the same time.

Given that there is no such thing as a device namespace, how does this work?

The docs seem a bit confusing to me as to whether there's a hierarchy
of domains.  Do domains have a concept of a parent?

What's "container-name"?

Given that domains have random IDs, how can they be checkpointed and restored?

--Andy
