Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3IZILc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:11:32 -0400
Received: from ppsw-mx-f.csi.cam.ac.uk ([131.111.8.149]:37120 "EHLO
	ppsw-42.csi.cam.ac.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008Ab3IZIL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:11:28 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2013 04:11:28 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] add exFAT driver
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20130925221006.GB32312@kroah.com>
Date: Thu, 26 Sep 2013 08:50:51 +0100
Cc: Alexander Holler <holler@ahsoftware.de>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CF1C280A-93D7-452B-B418-067AF327FA87@cam.ac.uk>
References: <20130830124622.5f81b7d4@rechenknecht2k7> <20130830154205.GA1411@kroah.com> <20130925183632.08a0d073@rechenknecht2k7> <20130925172704.GB5258@kroah.com> <20130925183235.GA9659@srcf.ucam.org> <20130925184539.GA4208@kroah.com> <52433978.9050302@ahsoftware.de> <20130925202151.GA6149@kroah.com> <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk> <20130925221006.GB32312@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25 Sep 2013, at 23:10, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 25, 2013 at 10:44:15PM +0100, Anton Altaparmakov wrote:
>> On 25 Sep 2013, at 21:21, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> On Wed, Sep 25, 2013 at 09:28:56PM +0200, Alexander Holler wrote:
>>>> 
>>>> Maybe a silly question, but isn't exFAT protected by some MS owned
>>>> patents which might drive Linux users into the hand of MS lawyers as
>>>> already happened with FAT?
>> 
>> Yes, it is.  You cannot use exFAT without a Microsoft patent license
>> (unless you live in countries without software patents perhaps).
> 
> Given that you that you are not a Microsoft representative, nor a
> Samsung employee, I don't understand how you can make such a definitive
> statement.

Have you actually read the source code that was released?

May I quote just one bit:

from exfat_1.2.4/exfat.c (available from http://opensource.samsung.com - just search for exfat) at the top:

/* Some of the source code in this file came from "linux/fs/fat/misc.c".  */
/*
 *  linux/fs/fat/misc.c
 *
 *  Written 1992,1993 by Werner Almesberger
 *  22/11/2000 - Fixed fat_date_unix2dos for dates earlier than 01/01/1980
 *         and date_dos2unix for date==0 by Igor Zhbanov(bsg@uniyar.ac.ru)
 */

That is somewhat conclusively a derivative work is it not?

Also, have a read of this article:

	http://www.phoronix.com/scan.php?page=news_item&px=MTQzODQ

Which explains further who made them open source it after they saw the leaked code on github.

So even without resorting to knowledge I may not discuss it is pretty conclusive that what I said is correct as anyone driving google can find for themselves as I pointed out above...

>>>> It would make me wonder if not. Maybe you could ask Samsung about
>>>> that too, when you are there.
>>> 
>>> Because Samsung released the code under the GPLv2, and their lawyers
>>> understand what that means, should answer any question you might have
>>> about this.
>> 
>> Sorry but you have no idea what you are talking about.
> 
> Ah, that's a lovely way to engage in a conversation.

I did say sorry!  (-;

>> Samsung modified the GPL-ed FAT driver to make it work with exFAT.
>> Therefore their exFAT driver was GPL as a derived work.  They got
>> caught and had to release the source code.
> 
> And now you claim to be a Samsung representative again, I think your
> country has some bad liable laws you might wish to watch out for...

I am not claiming anything and least of all to be representing Samsung!!!

Libel implies untruth and as you can see above I am only stating what anyone can readily find on google.

> This isn't going to go very far, so I'll just not respond anymore, it's
> not going to be productive, and given that I don't see your name on the
> code here, I don't see why I need to.
> 
> Please stick to technical discussions about the code on the kernel
> mailing lists.  Legal discussions can be left up to the lawyers, of
> which we are not.


I agree, but then please stop making public assertions that people can use the exfat driver legally.  You just yourself said you are not a lawyer so I do not understand how you can make your assertion!

If anyone cares, here is Microsoft's exFAT licensing page which I strongly recommend you read before you use that driver:

	http://www.microsoft.com/en-us/legal/intellectualproperty/IPLicensing/Programs/exFATFileSystem.aspx

Also if you search google for "exFAT patent" you can find some that way but there are also others that are not found that way but that are clearly essential for any exFAT implementation (according to the technical review I did of them).  I am not sure whether I am allowed to give a list or not so I will refrain from doing so.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

