Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3APNtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:49:04 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:43408 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3APNtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:49:02 -0500
Date: Wed, 16 Jan 2013 17:42:02 +0400
From: Volokh Konstantin <volokh84@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        mchehab@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        rdunlap@xenotime.net, hans.verkuil@cisco.com, justinmattock@gmail.com
Subject: Re: [PATCH 2/4] staging: media: go7007: firmware protection
 Protection for unfirmware load
Message-ID: <20130116134201.GA20944@VPir>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
 <1358341251-10087-2-git-send-email-volokh84@gmail.com>
 <20130116133545.GG4584@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116133545.GG4584@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 04:35:45PM +0300, Dan Carpenter wrote:
> The problem is that the firmware was being unloaded on disconnect?
> 
> regards,
> dan carpenter
If no firmware was loaded (no exists,wrong or some error) then rmmod fails with OOPS,
so need some protection stuff
> 
