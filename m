Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaAVR0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:26:08 -0500
Received: from ext3.cumulusnetworks.com ([198.211.106.187]:44670 "EHLO
	ext3.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaAVR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:26:05 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2014 12:26:05 EST
Date: Wed, 22 Jan 2014 09:18:12 -0800
From: Curt Brune <curt@cumulusnetworks.com>
To: Laszlo Papp <lpapp@kde.org>
Cc: LKML <linux-kernel@vger.kernel.org>, patrickdepinguin@gmail.com,
        gregkh@linuxfoundation.org, linux-i2c@vget.kernel.org
Subject: Re: [RFC] Creating an eeprom class
Message-ID: <20140122171812.GA29955@cumulusnetworks.com>
References: <CAOMwXhMvefuQJPZ_sbzySmvcyqkR+Lfh-11Gx3unGqyR2pREww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMwXhMvefuQJPZ_sbzySmvcyqkR+Lfh-11Gx3unGqyR2pREww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laszlo,

On Wed Jan 22 13:25, Laszlo Papp wrote:
> 
> Was there any progress done? I saw the following thread, too, so
> including CC in the loop:
> http://www.spinics.net/lists/linux-i2c/msg13141.html
> 

I have patches that adds a "eeprom_dev" class that I described in the
above thread.  The patches also show how to register the at24 driver
with the EEPROM class.

We have been using the patch in production for almost a year now, with
good success.

I will send the patches to linux-i2c@vget.kernel.org shortly.

Cheers,
Curt
