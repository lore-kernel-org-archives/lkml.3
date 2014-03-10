Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaCJPPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:15:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33127 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaCJPPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:15:16 -0400
Date: Mon, 10 Mar 2014 11:08:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RC6 Bell Chime] Re: [PATCH 00/24] rfcomm fixes
Message-ID: <20140310150858.GA25703@tuxdriver.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
 <3E0F3723-029F-4B12-8D77-9790FDBD3227@holtmann.org>
 <1259174563.20140212120644@eikelenboom.it>
 <1335661753.20140303203853@eikelenboom.it>
 <1295963563.20140310093843@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295963563.20140310093843@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 09:38:43AM +0100, Sander Eikelenboom wrote:
> Hi all,
> 
> Since:
> - 3.14-RC6 has been cut
> - this regression is known and reported since the merge window
> - the fix (revert of 3 patches) is known for over a month now
> - but it's still not in mainline
> - my polite ping request from last week seems to have provoked exactly 0 (zero) response.
> 
> IT'S TIME TO CHIME SOME BELLS :-)
> 
> Hope that WILL be heard somewhere ...
> 
> --
> Sander
> 
> PS. on the informative side the 3 commits to be reverted are:
> 
> f86772af6a0f643d3e13eb3f4f9213ae0c333ee4 Bluetooth: Remove rfcomm_carrier_raised()
> 4a2fb3ecc7467c775b154813861f25a0ddc11aa0 Bluetooth: Always wait for a connection on RFCOMM open()
> e228b63390536f5b737056059a9a04ea016b1abf Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()

Gustavo, should I be expecting a pull request?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
