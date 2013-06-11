Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3FKHXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:23:00 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56877 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3FKHW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:22:58 -0400
Date: Tue, 11 Jun 2013 10:22:45 +0300
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
        gustavo@padovan.org, linux-bluetooth@vger.kernel.org
Subject: Re: 3.10-rc: bluetooth disappeared on thinkpad x60 (regression)
Message-ID: <20130611072245.GA12463@x220>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
	gustavo@padovan.org, linux-bluetooth@vger.kernel.org
References: <20130610092907.GA5487@amd.pavel.ucw.cz>
 <20130610100519.GA9816@x220.ger.corp.intel.com>
 <20130610110423.GA8834@amd.pavel.ucw.cz>
 <20130610115938.GA12892@x220.ger.corp.intel.com>
 <20130610133834.GA4058@amd.pavel.ucw.cz>
 <20130610160723.GA18282@x220.P-661HNU-F1>
 <20130610193746.GA30801@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610193746.GA30801@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Mon, Jun 10, 2013, Pavel Machek wrote:
> < HCI Command: Delete Stored Link Key (0x03|0x0012) plen 7
>     bdaddr 00:00:00:00:00:00 all 1
> > HCI Event: Command Complete (0x0e) plen 4
>     Delete Stored Link Key (0x03|0x0012) ncmd 1
>     status 0x11 deleted 0
>     Error: Unsupported Feature or Parameter Value

Here's the cause of your issue. It's not one of the recently added HCI
commands but one that's been around for quite some time. I just checked
and it's even there in kernel 3.9, so I'm surprised that you're saying
this is a regression since that version. Are you completely sure about
it?

Johan
