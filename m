Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbaF0IX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:23:29 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37326 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaF0IX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:23:27 -0400
Message-ID: <1403857405.16560.0.camel@linux-fkkt.site>
Subject: Re: ext4: total breakdown on USB hdd, 3.0 kernel
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: tytso@mit.edu, kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jun 2014 10:23:25 +0200
In-Reply-To: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
References: <20140626202021.GA8512@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 22:20 +0200, Pavel Machek wrote:
> Hi!
> 
> Ok, this ext4 filesystem does _not_ have easy life: it is in usb
> envelope, I wanted
> to use it as a root filesystem, and it is connected to OLPC-1.75,
> running some kind
> of linux-3.0 kernels.
> 
> So power disconnects are common, and even during regular reboot, I
> hear disk doing
> emergency parking.
> 
> I don't know how barriers work over USB...

Just like with other SCSI devices.

	HTH
		Oliver


