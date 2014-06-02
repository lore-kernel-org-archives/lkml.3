Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaFBUug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:50:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:61649 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaFBUue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140602091242.GV15585@mwanda>
References: <1401629020-18518-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140602091242.GV15585@mwanda>
Date: Mon, 2 Jun 2014 22:50:34 +0200
Message-ID: <CAFo99gYOkJV7jU3cYYjSapti6Ji55Pk=VDAPFn1GmFTDera4pA@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c: Cleaning up
 uninitialized variables
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Manu Gupta <manugupt1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I mail about this for the first time in early May, but ther were many
other faults in the design of my patch then, had several different
types of errors in the same path etc.


So good that someone was inspired to make a real patch of it even then :)

And i'm getting the linux-next to check before I send any more patches.


Best regards
Rickard Strandqvist


2014-06-02 11:12 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sun, Jun 01, 2014 at 03:23:40PM +0200, Rickard Strandqvist wrote:
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>
> Someone already sent this one.  You should be working against
> linux-next.
>
> regards,
> dan carpenter
>
