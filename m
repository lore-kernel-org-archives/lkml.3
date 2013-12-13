Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab3LNATx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 19:19:53 -0500
Received: from longford.logfs.org ([213.229.74.203]:53298 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3LNATw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 19:19:52 -0500
Date: Fri, 13 Dec 2013 17:58:02 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Rob Landley <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Copy on write hard links?
Message-ID: <20131213225802.GA21911@logfs.org>
References: <0EF3994A-6BC7-4FC7-AD2D-B4BE087EBFCA@m3y3r.de>
 <1380117572.1974.81@driftwood>
 <1380119333.7453.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380119333.7453.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 September 2013 16:28:53 +0200, Thomas Meyer wrote:
> 
> I wonder how hard it would be to implement this on vfs layer?

As an ugly hack: a few weeks maybe.  Did it back in 2005 or so.  If
you have higher standards, you will need support from the underlying
filesystem.  Especially in order to make copying a large file on slow
storage anything but a nightmare.

Jörn

--
When in doubt, use brute force.
-- Ken Thompson
