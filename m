Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaJABil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 21:38:41 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58918 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750833AbaJABij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 21:38:39 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Darren Hart <dvhart@infradead.org>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/3] toshiba_acpi: Change HCI/SCI functions return code type
Date: Wed, 01 Oct 2014 03:58:34 +0200
Message-ID: <2951962.6yqkWfcajp@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140930205814.GB47302@vmdeb7>
References: <1412044809-3366-1-git-send-email-coproscefalo@gmail.com> <1412044809-3366-4-git-send-email-coproscefalo@gmail.com> <20140930205814.GB47302@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 30, 2014 01:58:14 PM Darren Hart wrote:
> On Mon, Sep 29, 2014 at 08:40:09PM -0600, Azael Avalos wrote:
> > Currently the HCI/SCI read/write functions are returning
> > the status of the ACPI call and also assigning the
> > returned value of the HCI/SCI function, however, only
> > the HCI/SCI status is being checked.
> > 
> > This patch changes such functions, returning the value
> > of the HCI/SCI function instead of the ACPI call status,
> > eliminating one parameter, and returning something
> > useful that indeed is being checked.
> > 
> > Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> 
> Cc linux-acpi
> 
> Rafael,
> 
> This follows a couple patches renaming interfaces and error codes. While
> there is some information to be had in checking for ACPI specific errors, I
> don't think it's significant to warrant asking Azael to go the other way and
> check for them specifically and add errorcodes to the interface rather than
> cleanup the functionality as it stands today and simplifiy the code as he does
> here.
> 
> Any objection?

Nope.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
