Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaFRW2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:28:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaFRW17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:27:59 -0400
Date: Wed, 18 Jun 2014 15:31:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: driverdevel <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre: Use %ld to format long
Message-ID: <20140618223158.GA15126@kroah.com>
References: <1402506054-7696-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdWX9gY=6npcVk6kLRGPq+wjg545AZEvphw0hW79bsympQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWX9gY=6npcVk6kLRGPq+wjg545AZEvphw0hW79bsympQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 08:59:45AM +0200, Geert Uytterhoeven wrote:
> Hi Greg,
> 
> On Wed, Jun 11, 2014 at 7:00 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > drivers/staging/lustre/lustre/llite/rw26.c: In function ‘ll_direct_IO_26’:
> > drivers/staging/lustre/lustre/llite/rw26.c:388: warning: format ‘%zd’ expects type ‘signed size_t’, but argument 6 has type ‘long int’
> > drivers/staging/lustre/lustre/llite/rw26.c:388: warning: format ‘%zd’ expects type ‘signed size_t’, but argument 10 has type ‘long int’
> >
> > Introduced by commit b41a1fe067c34b40736860458b9d62b2139471d5 ("staging:
> > lustre: Use %zd to format ssize_t"), which was part of a series to fix
> > issues in -next. However, the commits introducing the issues never made it
> > to mainline.
> 
> They have now, so please drop this patch.

Now dropped :)
