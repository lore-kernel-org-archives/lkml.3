Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3AVF6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 00:58:04 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:33120 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3AVF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 00:58:02 -0500
Message-ID: <50FE2A34.3050607@lab.ntt.co.jp>
Date: Tue, 22 Jan 2013 14:57:08 +0900
From: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [PATCH v2] HID: add support for Sony RF receiver with USB product
 id 0x0374
References: <1358221428.9926.1.camel@nexus.lab.ntt.co.jp>  <20130115103638.be566e39f0f5ad7186362dd8@studenti.unina.it>  <50F52986.2080002@lab.ntt.co.jp>  <1358246448.4897.3.camel@nexus.lab.ntt.co.jp>  <alpine.LNX.2.00.1301151702150.7734@pobox.suse.cz>  <50F637D1.8070302@lab.ntt.co.jp>  <alpine.LNX.2.00.1301161141250.14768@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1301161141250.14768@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 11:44 +0100, Jiri Kosina wrote:
> On Wed, 16 Jan 2013, Fernando Luis Vazquez Cao wrote:
>
> > I noticed that the patch was tagged "for-3.9". Does this mean
> > that it is too late to get it merged during the current release
> > cycle?
>
> I currently don't have anything queued for 3.8, and this particular patch
> doesn't justify a separate pull request.
>
> Once it's in Linus' tree, it can be easily pushed out to all existing
> -stable branches (including 3.8-stable, once it's created).
>
> If I am gfoing to be sending pull request for 3.8 to Linus still due to
> some important bugfix, I will be including this.

Ok, thank you for the explanation. I really appreciate it.


> > If possible, I would like to get it backported to 3.7-stable (and
> > possibly 3.2 stable), since without it a whole family of Sony desktop
> > computers is unusable under Linux out of the box. Should I do it myself
> > or do you have a process in place for HID stable patches?
>
> If the patch had
>
> 	Cc: stable@vger.kernel.org
>
> in it, it'd be picked for -stable queue automatically.

I considered doing that but I thought and upstream commit
ID was needed.


> Otherwise, anyone is free to take it once it's in Linus' tree and sent
> to to stable@vger.kernel.org for inclusion.


So it is the standard procedure. I just wanted to make
sure whether you wanted to have all the -stable patches
funnelled through you. I will send the patch to -stable
directly and Cc you as soon as it makes it into Linus'
tree.


By the way, I will be replying to this email with a
follow-up patch that I forgot to send the last time
around. It is just documentation for the quirk.

Thanks,
Fernando
