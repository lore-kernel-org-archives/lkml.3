Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaDDUJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:09:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbaDDUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:09:31 -0400
Date: Fri, 4 Apr 2014 13:11:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: jkc@redhat.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: unisys: verify that a control channel exists
Message-ID: <20140404201154.GA12617@kroah.com>
References: <1396636704-18542-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396636704-18542-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 02:38:24PM -0400, Sasha Levin wrote:
> The code didn't verify that a control channel exists before trying to
> use it. It caused NULL ptr derefs which were easy to trigger by an
> unpriviliged user simply by reading the proc file, causing:

Ugh, what a mess...

Thanks for this, I'll queue it up after 3.15-rc1 is out.

greg k-h
