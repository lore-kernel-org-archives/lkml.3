Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaLCMkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:40:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43579 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaLCMko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:40:44 -0500
Date: Wed, 3 Dec 2014 13:40:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Side effect of pressing special keys
Message-ID: <20141203124042.GA504@amd>
References: <201411231441.17592@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201411231441.17592@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-11-23 14:41:17, Pali Rohár wrote:
> Hello,
> 
> pressing some keys on laptops could cause some side effects.
> 
> Example scenario 1:
> 
> Laptop has Fn key for enabling/disabling WIFI and when that key 
> is pressed BIOS is doing two things:
> 
> 1) Switch hard rfkill state of WIFI
> 2) Report that Fn key was pressed to kernel
>    (either via i8042 bus or via ACPI/WMI)

We should not really report that as a "key" to userspace. We might
want to report that rfkill state changed....
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
