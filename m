Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141AbaFXQyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:54:19 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:52694 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754855AbaFXQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:54:17 -0400
Message-ID: <1403628854.1960.21.camel@x220>
Subject: Re: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 18:54:14 +0200
In-Reply-To: <Pine.LNX.4.44L0.1406241010160.990-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406241010160.990-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2014 16:54:14.0751 (UTC) FILETIME=[EE1556F0:01CF8FCC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 10:15 -0400, Alan Stern wrote:
> The default value for the persist facility depends on the setting of 
> CONFIG_USB_DEFAULT_PERSIST.  If that symbol is set then persist is 
> enabled by default for all devices, except those which have the 
> USB_QUIRK_RESET flag set (meaning that they will morph or change modes 
> when reset).  If the symbol is not set then persist is enabled by 
> default only for hubs.
> 
> Thanks for the documentation update.

You do expect a v2 updated to reflect your comments, don't you?


Paul Bolle 


