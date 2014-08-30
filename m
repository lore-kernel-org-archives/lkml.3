Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaH3VGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 17:06:18 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33495 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbaH3VGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 17:06:16 -0400
X-Sasl-enc: BTbJA4Q2ZlhoRMpQq+fC8RtKeMSs6n9AaBA0mfK0+KMQ 1409432775
Date: Sat, 30 Aug 2014 14:06:14 -0700
From: Greg KH <greg@kroah.com>
To: Koray Gulcu <koray.gulcu@ozu.edu.tr>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: android: sw_sync.c: fix new line style issues
Message-ID: <20140830210614.GA29515@kroah.com>
References: <1408995335-4041-1-git-send-email-koray.gulcu@ozu.edu.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408995335-4041-1-git-send-email-koray.gulcu@ozu.edu.tr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 08:35:31PM +0100, Koray Gulcu wrote:
> Add two new lines that are missing after declerations as detected by checkpatch.pl
> 
> Signed-off-by: Koray Gulcu <koray.gulcu@ozu.edu.tr>
> ---
>  drivers/staging/android/sw_sync.c |    2 ++
>  1 file changed, 2 insertions(+)

2 other people sent this same patch before you did :(

sorry,

greg k-h
