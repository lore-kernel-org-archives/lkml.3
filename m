Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaFBOeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:34:20 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:50564 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbaFBOeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:34:19 -0400
Date: Mon, 2 Jun 2014 16:33:47 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Mike Remski <mremski@mutualink.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: ftdi_sio BUG: NULL pointer dereference
Message-ID: <20140602143347.GA1902@localhost>
References: <538C8963.4010909@mutualink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C8963.4010909@mutualink.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:25:39AM -0400, Mike Remski wrote:
> Please CC me as not subscribed to list.
> Third party device, with FTDI chip on it.  Get this when plugging device 
> in.  Discovered in kernel 2.6.32

Wow, that kernel is ancient. Please upgrade to a more recent kernel such
as v3.14.5, or you need to get support from whatever vendor is forcing
you to use such an old kernel.

Good luck,
Johan
