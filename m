Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBIXFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 18:05:47 -0500
Received: from mail.wdtv.com ([66.118.69.84]:59395 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbaBIXFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 18:05:46 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 24/28] Remove DEPRECATED
Date: Sun, 9 Feb 2014 18:05:41 -0500
Cc: Richard Weinberger <richard@nod.at>, Guenter Roeck <linux@roeck-us.net>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402091741.46390.gheskett@wdtv.com> <1391986097.25855.94.camel@x220>
In-Reply-To: <1391986097.25855.94.camel@x220>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402091805.41618.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 February 2014, Paul Bolle wrote:
>On Sun, 2014-02-09 at 17:41 -0500, Gene Heskett wrote:
>> On Sunday 09 February 2014, Paul Bolle wrote:
>> >What has this got to do with an invalid Kconfig dependency in
>> >arch/mn10300?
>> 
>> Probably not much
>
>Feel free to open a new thread, with the relevant details, and involve
>the relevant people and lists. I have no idea what you're going on about
>and could not care less (in the context of this thread).
>
>
>Paul Bolle

Been tried, got zero response.  Frankly, posting just to lkml, hoping the 
revalent people see it, is beginning to act like posting to a black hole.

Somewhere between 3.4.36 and 3.8.2, 99% of it disappeared from an oldconfig 
output.  I don't have any trees between those two on my machine or I'd pin 
it down a little more specifically.

So who would the correct maintainer person be, for such as a "make 
oldconfig"?

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

