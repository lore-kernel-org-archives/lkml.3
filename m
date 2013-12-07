Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab3LGRKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:10:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3LGRKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:10:48 -0500
Date: Sat, 7 Dec 2013 09:12:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: serio - fix sysfs layout
Message-ID: <20131207171217.GA19016@kroah.com>
References: <20131207154116.GA9902@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131207154116.GA9902@core.coreip.homeip.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 07:41:19AM -0800, Dmitry Torokhov wrote:
> Restore previous layout of sysfs attributes that was broken by commit
> 3778a2129bcce84f684cc0017ed20d2524afd289 (input: serio: remove bus usage of
> dev_attrs) which moved all serio device attributes into 'id' group, when
> only 'type', 'proto', 'id', and 'extra' should be in 'id' group and the
> rest of attributes should be attached directly to the device.

Ick, sorry about that.

> Reported-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
