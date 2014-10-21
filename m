Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbaJUTnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:43:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58725 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaJUTnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:43:42 -0400
Date: Tue, 21 Oct 2014 20:43:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Bastien Nocera <hadess@hadess.net>, linux-kernel@vger.kernel.org
Subject: Re: A desktop environment[1] kernel wishlist
Message-ID: <20141021194340.GT7996@ZenIV.linux.org.uk>
References: <1413881397.30379.7.camel@hadess.net>
 <5446B3CC.1080904@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5446B3CC.1080904@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:28:12PM -0700, Andy Lutomirski wrote:

> Why is kdbus needed?

Presumably because freedesktop crowd has made an architectural mistake and
pushed dbus as solution to all problems.  And ran into limitations of
that, er, solution.  Then, instead of perhaps reconsidering the wisdom of
their inspired decision, went for "let's push it kernelwards, it might
somewhat reduce the overhead and problems will be easier to chalk up to
something wrong being done by the kernel".
