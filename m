Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3KXJHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:07:35 -0500
Received: from alt-proxy8.mail.unifiedlayer.com ([74.220.207.38]:40028 "HELO
	alt-proxy8.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751529Ab3KXJH1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:07:27 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Nov 2013 04:07:27 EST
Subject: Re: [PATCH] MAINTAINERS: Add an entry for the Macintosh HFSPlus Filesystem
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <20131114210617.4e68b086@alan.etchedpixels.co.uk>
Date: Sun, 24 Nov 2013 13:02:08 +0300
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B586EBD8-8CB6-4E65-BC01-7B038A1885D3@dubeyko.com>
References: <1384461563-4487-1-git-send-email-geert@linux-m68k.org> <20131114210617.4e68b086@alan.etchedpixels.co.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 15, 2013, at 12:06 AM, One Thousand Gnomes wrote:

> On Thu, 14 Nov 2013 21:39:23 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
>> To make scripts/get_maintainer.pl output something sensible.
>> 
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>> I guess it's orphaned, just like HFS?
> 
> Looking at bugzilla - yes

What do you means by orphaned? If you means absence of implementation or bug fix
then I disagree completely. Because I am making some implementation activity for
HFS+. If you are talking about absence of using HFS+ by ordinary users then I disagree again.
Because, as far as I can see, there are many Apple devices that it has HFS+ file system
then it makes sense to have actual support for HFS+ file system under Linux.

With the best regards,
Vyacheslav Dubeyko.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

