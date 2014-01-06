Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaAFVKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:10:10 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51070 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbaAFVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:10:06 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 6 Jan 2014 13:09:56 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140106210956.GA24603@leaf>
References: <20140106204706.GA16924@leaf>
 <20140106130003.4eea0893605369a8fd9336ac@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106130003.4eea0893605369a8fd9336ac@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:00:03PM -0800, Andrew Morton wrote:
> On Mon, 6 Jan 2014 12:47:07 -0800 Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > Does anyone have any objection to the use of "#pragma once" instead of
> > the usual #ifndef-#define-...-#endif include guard?
> 
> Sounds OK to me.  gcc has supported this for quite a long time, yes?  I
> wonder if ICC supports it.

Yes, ICC supports it as well, if anyone cares.

- Josh Triplett
