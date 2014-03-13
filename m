Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaCMBsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:48:08 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50924 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaCMBsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:48:05 -0400
Date: Thu, 13 Mar 2014 10:48:03 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-serial@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] serial: sh-sci: Neaten dev_<level> uses
Message-ID: <20140313014803.GP25813@verge.net.au>
References: <1394532680-4264-1-git-send-email-geert@linux-m68k.org>
 <1394548060.21085.45.camel@joe-AO722>
 <1394557846.21085.54.camel@joe-AO722>
 <CAMuHMdXkLkMOhoiqJ8cxZMUm6SnaxC5WV=a2w=bv1=KW6nyqwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXkLkMOhoiqJ8cxZMUm6SnaxC5WV=a2w=bv1=KW6nyqwQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 07:55:50PM +0100, Geert Uytterhoeven wrote:
> Hi Joe,
> 
> On Tue, Mar 11, 2014 at 6:10 PM, Joe Perches <joe@perches.com> wrote:
> > Add missing newlines and coalesce formats.
> > Realign arguments.
> 
> Thanks!
> 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

Greg, could you pick up this one too?

