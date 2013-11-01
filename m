Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3KAQYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:24:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3KAQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:24:18 -0400
Date: Fri, 1 Nov 2013 09:24:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?0JDQu9C10LrRgdC10Lkg0JrRgNCw0LzQsNGA0LXQvdC60L4=?= 
	<alexeyk13@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: FTDI custom VID/PID patch
Message-ID: <20131101162417.GA32287@kroah.com>
References: <5273AC0E.3010005@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5273AC0E.3010005@yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 05:26:38PM +0400, Алексей Крамаренко wrote:
> Hello Greg.
> 
> It's my first patch, sorry if something wrong.
> 
> Custom VID/PID for Z3X Box device, popular tool for cellphone flashing.

A few meta-comments.  Your patch had the tabs turned into spaces, the
lines were line-wrapped, and you put the Signed-off-by: at the bottom of
the patch, not up here in the changelog area.  I've fixed it up by hand,
but in the future, please work to fix your email client to not mutilate
patches.

thanks,

greg k-h
