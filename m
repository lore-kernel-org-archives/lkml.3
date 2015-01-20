Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbbATWBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:01:06 -0500
Received: from mail.sig21.net ([80.244.240.74]:36902 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbATWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:01:04 -0500
Date: Tue, 20 Jan 2015 23:00:28 +0100
From: Johannes Stezenbach <js@sig21.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Josh Boyer <jwboyer@fedoraproject.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 01/13] kdbus: add documentation
Message-ID: <20150120220028.GA13191@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
 <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org>
 <54BE5DC8.70706@gmail.com>
 <CANq1E4SjfZOKqTsdkt519vKc1Poeah5McVJBb_spdHjbKv4=7g@mail.gmail.com>
 <CA+5PVA46wVa-L9K1zgHzt=Fwn6YFBYhxJUjiozSH4XBY03WMVw@mail.gmail.com>
 <20150120145353.GA8124@dztty>
 <20150120160842.GA9474@sig21.net>
 <CANq1E4Q9m7JRXNYFY4okh3brM-kHVoVGOdF_SWjNoNURX930HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4Q9m7JRXNYFY4okh3brM-kHVoVGOdF_SWjNoNURX930HQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Jan 20, 2015 at 06:00:28PM +0100, David Herrmann wrote:
[big snip]
> These are just examples off the top of my head, but I think they're
> already pretty convincing.

Thank you for writing this up.  This is the information I was
looking for which puts kdbus into context and explains
the motivation for its development.  Naturally I don't agree
with all of it, but I'm content with what I learned so far.

Daniel informed me off-list that he (and probably others) does
not understand what my questions were aiming at.  I'm sorry
about that, I thought it was clear I was just lacking
the background information to understand what kdbus is and
what it is not, and why it exists -- information I couldn't find
in some hours of googling.


Thanks,
Johannes
