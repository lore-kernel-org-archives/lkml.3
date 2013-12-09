Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab3LIOnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:43:02 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52481 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761121Ab3LIOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:42:58 -0500
Message-ID: <1386600171.7152.165.camel@host5.omatika.ru>
Subject: Re: [PATCH 3/9] ARM: fix ohci-pxa27x build error with OF enabled
From: Sergei Ianovich <ynvich@gmail.com>
To: Steve Cotton <steve@s.cotton.clara.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:USB OHCI DRIVER" <linux-usb@vger.kernel.org>
Date: Mon, 09 Dec 2013 18:42:51 +0400
In-Reply-To: <20131209142605.GA9345@s.cotton.clara.co.uk>
References: <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <1386543229-1542-4-git-send-email-ynvich@gmail.com>
	 <20131209142605.GA9345@s.cotton.clara.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 14:26 +0000, Steve Cotton wrote:
> There's already a different patch for this
> in the linux-next/master and gregkh/usb/usb-linus trees, but
> not in the linux-next/stable or gregkh/usb/usb-next trees.
> 
> It adds that include 3 lines higher up, to keep the includes in
> alphabetical order.

Thanks.

