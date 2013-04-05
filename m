Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161910Ab3DEPhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 11:37:36 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45970 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3DEPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 11:37:34 -0400
Date: Fri, 5 Apr 2013 08:37:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hang while add block device to raid1
Message-ID: <20130405153732.GB515@kroah.com>
References: <CACaajQsTwWU+YVhp550365Bhyh3C-R=t1DFqmY=1T_2WEqfR+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACaajQsTwWU+YVhp550365Bhyh3C-R=t1DFqmY=1T_2WEqfR+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 04:13:40PM +0400, Vasiliy Tolstov wrote:
> Hello. I'm use kernel 3.6.11 from stable tree.

Which is no longer supported, can you duplicate this on the 3.8 stable
tree?

thanks,

greg k-h
