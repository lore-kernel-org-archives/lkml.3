Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3ILHyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:54:14 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:25853 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755642Ab3ILHyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:54:10 -0400
Date: Thu, 12 Sep 2013 09:53:33 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: "Gary E. Miller" <gem@rellim.com>
Cc: Paul Chavent <Paul.Chavent@onera.fr>, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        linux-kernel@vger.kernel.org
Message-ID: <20130912075333.GC6521@enneenne.com>
Mail-Followup-To: "Gary E. Miller" <gem@rellim.com>,
	Paul Chavent <Paul.Chavent@onera.fr>, linux-usb@vger.kernel.org,
	gregkh@linuxfoundation.org, jhovold@gmail.com,
	fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
	linux-kernel@vger.kernel.org
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
 <20130910073105.GB5030@enneenne.com>
 <20130910130234.5106a5bc.gem@rellim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910130234.5106a5bc.gem@rellim.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.10
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 0/5] Enable PPS reporting for USB serial devices
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on goldrake.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 01:02:34PM -0700, Gary E. Miller wrote:
> 
> Sure PPS over a local UART is 10 to 100 times better, but often PPS
> over USB is your best second choice.  As serial ports become extinct
> it may become your best choice.

Ok. But, please, add a note about it into PPS documentation and/or
(better) in configuration menu! :)

Then you can add my "Acked-by: Rodolfo Giometti <giometti@enneenne.com>"

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
