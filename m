Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3I3It6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:49:58 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:46559 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3I3It5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:49:57 -0400
Date: Mon, 30 Sep 2013 10:49:45 +0200
From: Robert Richter <rric@kernel.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm, kbuild: make "make install" not depend on vmlinux
Message-ID: <20130930084945.GA1963@rric.localhost>
References: <20130710133742.GA29368@emu.suse.cz>
 <CA+55aFxtvT3Yvbxe5JGBThZS13payymFJ7jCLyEiE2iNDvsZtQ@mail.gmail.com>
 <20130711135445.GA21500@sepie.suse.cz>
 <CA+55aFyVjugxM7cUDWi0ASWttYthCxa6e7X3CADknBcSFxWgew@mail.gmail.com>
 <20130712105721.GF8731@rric.localhost>
 <20130717160506.GI8731@rric.localhost>
 <CA+55aFx4G5gME3ByqE0Wr-_t2x_6WkP3Ta4k1z4jfW+PrcK0og@mail.gmail.com>
 <20130717165743.GK8731@rric.localhost>
 <CA+55aFzhmV7iq+Pv37trMCmdNzk53ORAoj0a6rV14fzKta3Dhw@mail.gmail.com>
 <51E7B3D0.4060609@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E7B3D0.4060609@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.07.13 11:22:24, Michal Marek wrote:
> > So Michal (or ARM people - whoever wants to take the patch), just take
> > my ack. No objections.
> 
> I can add it to the kbuild tree if needed. Otherwise you can add
> Acked-by: Michal Marek <mmarek@suse.cz>.

This didn't make it upstream yet, can somebody at it to a tree?

Thanks,

-Robert
