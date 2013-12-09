Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab3LIHxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:53:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760663Ab3LIHxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:53:09 -0500
Message-ID: <1386575586.2557.3.camel@linux-fkkt.site>
Subject: Re: xhci_hcd debugging status, please?
From: Oliver Neukum <oneukum@suse.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Date: Mon, 09 Dec 2013 08:53:06 +0100
In-Reply-To: <52A45D63.5060100@xs4all.nl>
References: <52A45D63.5060100@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 12:52 +0100, Udo van den Heuvel wrote:
> Hello,
> 
> Can someone please summarise the status of the xhci_hcd debugging I
> found after booting into 3.12.2?
> I did not see these messages before and I do not yet understand the
> added value for a mere user of this exciting xhci technology.
> Can we please have them go away if really there's noting really wrong?
> See below for a small part of the stream of stuff that was started.

You have XHCI debugging on. This is most likely a side effect
of teh switch to dynamic debugging in 3.12. But this should be
discussed on linux-usb.

	HTH
		Oliver


