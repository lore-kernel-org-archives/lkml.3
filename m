Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbbANJ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:29:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48664 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANJ3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:29:32 -0500
Date: Wed, 14 Jan 2015 12:28:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        John Stultz <john.stultz@linaro.org>, Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: Re: [PATCH] staging: android: fix coding style error (v2)
Message-ID: <20150114092844.GE5571@mwanda>
References: <1421224883.2847.3.camel@perches.com>
 <1421226636-5354-1-git-send-email-patrick.boettcher@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421226636-5354-1-git-send-email-patrick.boettcher@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the v2 in "[PATCH v2]" so that it gets removed and not stored in the
permanent changelog.

On Wed, Jan 14, 2015 at 10:10:36AM +0100, Patrick Boettcher wrote:
> Simple style fix - 80 char limit was exceeded.
> 
> This is second version of the patch. Thanks Joe Perches.

Put this line under the -- cut off.

> 
> Context: eudyptula challenge (http://eudyptula-challenge.org/)

Don't write this line.

> 
> Signed-off-by: Patrick Boettcher <patrick.boettcher@posteo.de>
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Peter Senna Tschudin <peter.senna@gmail.com>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: Tapasweni Pathak <tapaswenipathak@gmail.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: devel@driverdev.osuosl.org
> Cc: linux-kernel@vger.kernel.org

This block is not needed.  This is a whitespace patch not something
controversial where we will need to look at who was CC'd so that we
can get annoyed at them for ignoring critical information.

regards,
dan carpenter


