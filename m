Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaAMVxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:53:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAMVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:53:15 -0500
Date: Mon, 13 Jan 2014 13:53:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <cyborg101010@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        abbotti@mev.co.uk, dan.carpenter@oracle.com
Subject: Re: [PATCH] DAS1800: Fixing foo * bar should be foo *bar
Message-ID: <20140113215351.GA27772@kroah.com>
References: <1389649679-19605-1-git-send-email-cyborg101010@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389649679-19605-1-git-send-email-cyborg101010@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 09:47:59PM +0000, Joe Borg wrote:
> Fixed an error flagged by checkpatch.pl, 'foo * bar should be foo *bar' in the parameters of function munge_data().

Please wrap your changelog comments at 72 colums, like git asks you to
when you type them in.

> Signed-off-by Joe Borg <cyborg101010@gmail.com>

No "ġ"?

