Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3IJRH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:07:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57350 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3IJRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:07:50 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1309101250220.1075-100000@iolanthe.rowland.org>
References: <1378831050-22262-1-git-send-email-teg@jklm.no> <Pine.LNX.4.44L0.1309101250220.1075-100000@iolanthe.rowland.org>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 10 Sep 2013 19:07:29 +0200
Message-ID: <CAPXgP13Vh0OkrKCZ5F+=Q6cGFsp_maZxfS2OQ=bdHL-x8_nrJg@mail.gmail.com>
Subject: Re: [PATCH] usb: ohci/uhci - add soft dependencies on ehci_hcd
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tom Gundersen <teg@jklm.no>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-modules@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 7:02 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> Where is MODULE_SOFTDEP defined?  It isn't mentioned in any .h files in
> my kernel tree.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7cb14ba75d57910cc4b62115dd5db7bd83c93684

Kay
