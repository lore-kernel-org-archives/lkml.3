Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaDXWQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:16:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaDXWQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:16:17 -0400
Date: Thu, 24 Apr 2014 15:19:10 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rainer Weikusat <rweikusat@mobileactivedefense.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.4 03/27] net: unix: non blocking recvmsg() should not
 return -EINTR
Message-ID: <20140424221910.GA4098@kroah.com>
References: <20140424215551.942390050@linuxfoundation.org>
 <20140424215552.041408348@linuxfoundation.org>
 <874n1i8jzh.fsf@sable.mobileactivedefense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n1i8jzh.fsf@sable.mobileactivedefense.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:01:54PM +0100, Rainer Weikusat wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > 3.4-stable review patch.  If anyone has any objections, please let me
> > know.
> 
> Since this is a machine generated bulk e-mail (as far as I understand
> this) which is specifically not intended to be sent to me as person, as
> per Eric Dumazet earlier statements, I object to being on the recipient
> list without an opportunity to be removed from it as I have repeatedly
> requested.

Yes, you are right, this is an automated email, based on the changelog
comments in the kernel source tree, sorry about that.

> Insofar my understanding of European spam legislation goes, this is
> illegal.

Glad I don't live in Europe :)

greg k-h
