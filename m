Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbaFSRfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:35:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59990 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934008AbaFSRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:35:50 -0400
Date: Thu, 19 Jun 2014 13:35:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [usb resume regression] in 3.16-rc1
In-Reply-To: <CADDKRnAm1FFhqB9PkWDcyY2DC-0WrVc_mfwCxKc51CZ+Z_ZJVQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1406191331070.1247-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Jörg Otte wrote:

> I don't know how to do this.

To enable dynamic debugging (as root):

    echo 'module usbcore =p' >/sys/kernel/debug/dynamic_debug/control
    echo 'module ehci_hcd =p' >/sys/kernel/debug/dynamic_debug/control

Do this before you carry out the suspend, and post the resulting dmesg 
log.

Alan Stern

