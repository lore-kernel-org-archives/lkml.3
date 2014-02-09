Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBIQ3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:29:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBIQ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:29:45 -0500
Date: Sun, 9 Feb 2014 08:31:42 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Raymond Wanyoike <raymond.wanyoike@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, bjorn@mork.no
Subject: Re: [RFC] usb: option: blacklist ZTE MF667 net interface
Message-ID: <20140209163142.GB11774@kroah.com>
References: <1391936386-2890-1-git-send-email-raymond.wanyoike@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391936386-2890-1-git-send-email-raymond.wanyoike@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 11:59:46AM +0300, Raymond Wanyoike wrote:
> Interface #5 of 19d2:1270 is a net interface which has been submitted to the
> qmi_wwan driver so consequently remove it from the option driver.
> 
> Signed-off-by: Raymond Wanyoike <raymond.wanyoike@gmail.com>
> ---
>  drivers/usb/serial/option.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Why is this patch a "RFC"?
