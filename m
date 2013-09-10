Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab3IJHbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:31:24 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:14031 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754316Ab3IJHbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:31:22 -0400
Date: Tue, 10 Sep 2013 09:31:05 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        linux-kernel@vger.kernel.org
Message-ID: <20130910073105.GB5030@enneenne.com>
Mail-Followup-To: Paul Chavent <Paul.Chavent@onera.fr>,
	linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
	jhovold@gmail.com, fschaefer.oss@googlemail.com, jslaby@suse.cz,
	max@suse.de, linux-kernel@vger.kernel.org
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
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

On Mon, Sep 09, 2013 at 06:01:15PM +0200, Paul Chavent wrote:
> Hi.
> 
> This series enable the PPS reporting for USB serial devices.

I have nothing against with this solution but consider that reporting
a PPS signal through USB bus may add unknown delays that may vanish
clock stability... as far as I know you should not use USB serial port
with PPS. Have you some statistics about clock stability in a real
implementation?

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
