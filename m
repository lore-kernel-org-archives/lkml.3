Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbaFXQ6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:58:46 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56540 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbaFXQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:58:44 -0400
Message-ID: <1403629121.1960.25.camel@x220>
Subject: Re: [PATCH] USB: remove CONFIG_USB_PERSIST from Documentation
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-usb@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 18:58:41 +0200
In-Reply-To: <Pine.LNX.4.44L0.1406241017250.990-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406241017250.990-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2014 16:58:41.0797 (UTC) FILETIME=[8D415350:01CF8FCD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 10:25 -0400, Alan Stern wrote:
> Also, that "Later kernels" thing has already arrived.  I believe it was 
> implemented in 2.6.35.

How does the kernel currently call the disconnect method? I can't yet
say for sure, and it seems silly to send a v2 dropping those lines
without actually knowing why they can be dropped.

Thanks,


Paul Bolle


