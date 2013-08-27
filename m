Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3H0Vra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:47:30 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:57924 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab3H0Vr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <878uzmhkqg.fsf@xmission.com>
References: <878uzmhkqg.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 Aug 2013 14:47:07 -0700
Message-ID: <CALCETrWPDzuoaJp2ko5jAbwYUBqSdPjvO5uGo-gZVsS4Wm1PKQ@mail.gmail.com>
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and
 sysfs can be mounted
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 2:44 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Rely on the fact that another flavor of the filesystem is already
> mounted and do not rely on state in the user namespace.

Possibly dumb question: does this check whether the pre-existing mount
has hidepid set?

--Andy
