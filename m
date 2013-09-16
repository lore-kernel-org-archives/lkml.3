Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3IPIIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:08:31 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:29459 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181Ab3IPII3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:08:29 -0400
Date: Mon, 16 Sep 2013 10:08:09 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Chavent <Paul.Chavent@onera.fr>
Cc: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        linux-kernel@vger.kernel.org
Message-ID: <20130916080809.GJ6521@enneenne.com>
Mail-Followup-To: Paul Chavent <Paul.Chavent@onera.fr>,
	linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
	jhovold@gmail.com, fschaefer.oss@googlemail.com, jslaby@suse.cz,
	max@suse.de, linux-kernel@vger.kernel.org
References: <1379313660-2510-1-git-send-email-paul.chavent@onera.fr>
 <1379313660-2510-3-git-send-email-paul.chavent@onera.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379313660-2510-3-git-send-email-paul.chavent@onera.fr>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.10
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 2/2] USB : serial : invoke dcd_change ldisc's handler.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on goldrake.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 08:41:00AM +0200, Paul Chavent wrote:
> The DCD pin of the serial port can receive a PPS signal. By calling
> the port line discipline dcd handle, this patch allow to monitor PPS
> through USB serial devices.
> 
> However the performance aren't as good as the uart drivers, so
> document this point too.
> 
> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>

Acked-by: Rodolfo Giometti <giometti@enneenne.com>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
