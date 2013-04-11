Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3DKTEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:04:12 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34260 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DKTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:04:09 -0400
Date: Thu, 11 Apr 2013 12:04:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Zawora <pzawora@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [ 03/19] reiserfs: Fix warning and inode leak when deleting
 inode with xattrs
Message-ID: <20130411190406.GA27184@kroah.com>
References: <20130410225026.833809117@linuxfoundation.org>
 <20130410225027.171506481@linuxfoundation.org>
 <51666763.5050102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51666763.5050102@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 09:33:55AM +0200, Pawel Zawora wrote:
> After 4 days  with patch  filesystem is clean  (15 mln files
> deleted/unlinked, 17 mln files created or hardlinked ), no errors in
> dmesg.
> Test of  files ACL - passed  (tested ~100 000 files/dirs)

Wonderful, thanks for letting us know.

greg k-h
