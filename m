Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3JFXFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 19:05:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab3JFXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 19:05:09 -0400
Date: Sun, 6 Oct 2013 16:05:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCHv2] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006230534.GB7110@kroah.com>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
 <20131006211855.GB19510@leaf>
 <1381094837.2081.160.camel@joe-AO722>
 <20131006213309.GO19510@leaf>
 <1381096127.2081.166.camel@joe-AO722>
 <20131006222342.GT19510@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006222342.GT19510@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 03:23:42PM -0700, Josh Triplett wrote:
> Kernel maintainers reject new instances of the GPL boilerplate paragraph
> directing people to write to the FSF for a copy of the GPL, since the
> FSF has moved in the past and may do so again.
> 
> Make this an error for new code, but just a --strict CHK in --file mode;
> anyone interested in doing tree-wide cleanups of this form can enable
> this test explicitly.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
