Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaDMBdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:33:31 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:56728 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaDMBd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140409155934.GA27116@sepie.suse.cz>
References: <20140409155934.GA27116@sepie.suse.cz>
Date: Sat, 12 Apr 2014 18:33:27 -0700
X-Google-Sender-Auth: Q8VNPNSnH1GDKZFO59znqn5EqXk
Message-ID: <CA+55aFx_idf7XmBoBDsg81dwo9ufW24Ka_-zz1ru-ACAt+yJGw@mail.gmail.com>
Subject: Re: [GIT] kbuild misc changes for v3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: fabf@skynet.be, jason@lakedaemon.net,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 8:59 AM, Michal Marek <mmarek@suse.cz> wrote:
>
> here is the non-critical part of kbuild:

Michal, please make your pull request script clearly say both "git"
and "pull" somewhere. Your emails don't trigger my search criteria, so
they end up not being visible in my list of pull requests.

Most people do it in the subject, with "[GIT PULL]" at the beginning
of the subject line.

Others (like David Miller) end up having just "[GIT]" like you, but
then have a "Please pull" in the message body, making it match my
pattern. As it is, you only have that "git" part, although sometimes
occasionally you have "please pull" in the free-form section. But not
always, and not in this case, for example.

This pull request literally almost dropped through the cracks due to
this, so this is not some theoretical issue.

            Linus
