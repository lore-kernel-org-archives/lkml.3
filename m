Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3IZINa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:13:30 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:42326 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3IZIN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:13:27 -0400
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: [PATCH] add exFAT driver
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <524363AF.1040502@ahsoftware.de>
Date: Thu, 26 Sep 2013 08:54:02 +0100
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        STAGING SUBSYSTEM <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D6D1A293-C56E-4C98-82D1-3EBF95062B6B@cam.ac.uk>
References: <20130830124622.5f81b7d4@rechenknecht2k7> <20130830154205.GA1411@kroah.com> <20130925183632.08a0d073@rechenknecht2k7> <20130925172704.GB5258@kroah.com> <20130925183235.GA9659@srcf.ucam.org> <20130925184539.GA4208@kroah.com> <52433978.9050302@ahsoftware.de> <20130925202151.GA6149@kroah.com> <57387214-F138-4471-996E-3FB1ED28346C@cam.ac.uk> <20130925221006.GB32312@kroah.com> <524363AF.1040502@ahsoftware.de>
To: Alexander Holler <holler@ahsoftware.de>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25 Sep 2013, at 23:29, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 26.09.2013 00:10, schrieb Greg Kroah-Hartman:
>> Please stick to technical discussions about the code on the kernel
>> mailing lists.  Legal discussions can be left up to the lawyers, of
>> which we are not.
> 
> Hmm, but I would like to know if someone has to fear getting owned by
> Microsoft if he would use that driver.
> 
> Giving the rumours about Linux companies having to pay Microsoft and
> giving the fact that all of those licencees seem to don't have to speak
> about what Microsoft claims patents for and for what they have to pay, I
> obviously think adding that driver to Linux and thus making exFAT more
> general accepted is a very bad idea.
> 
> Of course, I'm not a lawyer too, but as a responsible Linux developer, I
> should at least be able to warn other parities when they approach me and
> want to use exFAT. Doing such without the maybe necessary license might
> drive small companies into the ground because most of them are unable to
> even think about having the money needed to talk with Microsoft lawyers
> in front of a court.


Exactly.  That is all I was trying to do.  Warn people/companies not to use the driver because they may get sued for using it.  As the below Microsoft exFAT licensing page says at the bottom:

<quote>
Please note that open source or other publicly available implementations of exFAT do not include an IP license from Microsoft. For licensing information, please contact IPlicreq@microsoft.com.
</quote>

Above is from bottom of:

	http://www.microsoft.com/en-us/legal/intellectualproperty/IPLicensing/Programs/exFATFileSystem.aspx

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge
J.J. Thomson Avenue, Cambridge, CB3 0RB, UK

