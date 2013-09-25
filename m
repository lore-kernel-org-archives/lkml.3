Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3IYVoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:44:23 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:48964 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3IYVoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:44:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] add exFAT driver
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20130925202151.GA6149@kroah.com>
Date: Wed, 25 Sep 2013 22:44:15 +0100
Cc: Alexander Holler <holler@ahsoftware.de>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk>
References: <20130830124622.5f81b7d4@rechenknecht2k7> <20130830154205.GA1411@kroah.com> <20130925183632.08a0d073@rechenknecht2k7> <20130925172704.GB5258@kroah.com> <20130925183235.GA9659@srcf.ucam.org> <20130925184539.GA4208@kroah.com> <52433978.9050302@ahsoftware.de> <20130925202151.GA6149@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25 Sep 2013, at 21:21, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 25, 2013 at 09:28:56PM +0200, Alexander Holler wrote:
>> 
>> Maybe a silly question, but isn't exFAT protected by some MS owned
>> patents which might drive Linux users into the hand of MS lawyers as
>> already happened with FAT?

Yes, it is.  You cannot use exFAT without a Microsoft patent license (unless you live in countries without software patents perhaps).

>> It would make me wonder if not. Maybe you could ask Samsung about that too, when you are there.
> 
> Because Samsung released the code under the GPLv2, and their lawyers
> understand what that means, should answer any question you might have
> about this.

Sorry but you have no idea what you are talking about.  Samsung modified the GPL-ed FAT driver to make it work with exFAT.  Therefore their exFAT driver was GPL as a derived work.  They got caught and had to release the source code.

It has NOTHING to do with what their lawyers understand, etc, and if you are really going to be visiting Samsung and if they are willing to talk to you about it you will be retracting what you wrote above in a hurry...  Sorry I cannot say more but I strongly suggest NOT to use this "GPL-ed exFAT driver" under any circumstances unless you get a patent license from Microsoft first.

Best regards,

	Anton

> thanks,
> 
> greg k-h

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

