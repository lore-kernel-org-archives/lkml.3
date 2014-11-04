Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaKDIrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:47:21 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:35673 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaKDIrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:47:18 -0500
Date: Tue, 4 Nov 2014 09:44:06 +0100
From: Johan Hovold <johan@kernel.org>
To: Anton Staaf <robotboy@chromium.org>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olofj@chromium.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] USB: simple: add Google simple serial SubClass support
Message-ID: <20141104084406.GJ31358@localhost>
References: <1414616030-37346-1-git-send-email-robotboy@chromium.org>
 <1415033000-28530-1-git-send-email-robotboy@chromium.org>
 <CANLzEkswS4rKGhJmkxF95nWWfyVxdv3REr+SmF6smuj_G0JBXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLzEkswS4rKGhJmkxF95nWWfyVxdv3REr+SmF6smuj_G0JBXg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:59:59AM -0800, Benson Leung wrote:
> On Mon, Nov 3, 2014 at 8:43 AM, Anton Staaf <robotboy@chromium.org> wrote:
> > Add support for Google devices that export simple serial
> > interfaces using the vendor specific SubClass/Protocol pair
> > 0x50/0x01.
> >
> > Signed-off-by: Anton Staaf <robotboy@chromium.org>
> 
> Reviewed-by: Benson Leung <bleung@chromium.org>

Applied to next, thanks.

Johan
