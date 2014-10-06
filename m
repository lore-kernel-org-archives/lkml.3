Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaJFKKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:10:09 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48989 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:10:07 -0400
Date: Mon, 6 Oct 2014 11:10:02 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [next-20141003] USB: host: st: fix typo
 'CONFIG_USB_EHCI_HCD_ST'
Message-ID: <20141006101002.GA7481@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1412324504.19413.76.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412324504.19413.76.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Oct 2014, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Fixes: 905e300e1043 ("USB: host: st: fix ehci/ohci driver selection")

Acked-by: Peter Griffin <peter.griffin@linaro.org>
