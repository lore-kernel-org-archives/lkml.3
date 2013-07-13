Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3GMH6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 03:58:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63850 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3GMH6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 03:58:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH] misc: add driver for Renesas R-Car Gyro-ADC/speed-pulse interfaces
Date: Sat, 13 Jul 2013 09:58:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
References: <201307130351.42967.sergei.shtylyov@cogentembedded.com> <20130713005702.GA14788@kroah.com> <51E0AA24.6070203@cogentembedded.com>
In-Reply-To: <51E0AA24.6070203@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307130958.16533.arnd@arndb.de>
X-Provags-ID: V02:K0:Adif1FQbcqevMkIPMg2Nh9E+KoTKMayJ4GHc7FRjLp2
 VLvgcUPdX8n93zNkEeLkchiUjrQLIKgKehE+lp/ACPbkYr3KIq
 SRWAwTJA/nFI5CK70UVKimPyuTPRupadnwn8U+VFQqimWuEE/b
 xqVotnc5ntZHzWjSZ50+leLpMkWK2uajB39OpWr1vXudKt5NP4
 HWDu6cK2NjNWcQ3oFyPgKWC9FZv+nLE66I2CubtBS4y9S8NJgZ
 +2SKkFqDmnKsJyQAZ3VgwYZ6CcWFjdoZpqN5+lhFKp/PVqLjn9
 aIMXzDvATDHY2xEMo6Obk7XinoBBG7Eghw7awXSnqaPPhU8KUI
 kVWmtePCLfwv0/Rc3pSQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 July 2013, Sergei Shtylyov wrote:
> > And are you sure you want to control this through sysfs?  There's no
> > other better user/kernel apis for it?
> 
>     I found none, besides ioctl(), as the device driven is rather 
> unique. But I thought that sysfs is "ioctl() today", so I went with it...
> 

It does sound like it would fit better into IIO than just a misc driver,
even if it's the only hardware of its kind.

	Arnd
