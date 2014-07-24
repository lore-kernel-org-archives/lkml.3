Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbaGXLiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:38:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbaGXLh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:37:59 -0400
Message-ID: <1406201840.729.4.camel@linux-fkkt.site>
Subject: Re: [PATCH 00/10 linux-next] drivers/usb: remove unnecessary break
 after goto/return
From: Oliver Neukum <oneukum@suse.de>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jul 2014 13:37:20 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-24 at 10:18 +0200, Fabian Frederick wrote:
> Small patchset addressing break redundancy on drivers/usb branch
> (suggested by Joe Perches).

Frankly, that is not a good idea. Somebody will remove a "goto"
and forget to readd the "break"

	Regards
		Oliver


