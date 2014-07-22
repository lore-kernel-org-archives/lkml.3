Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaGVO5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:57:01 -0400
Received: from mail.virtall.com ([178.63.195.102]:48960 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbaGVO47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:56:59 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2014 10:56:59 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=virtall.com; h=to:subject
	:mime-version:content-type:content-transfer-encoding:date:from
	:message-id; q=dns; s=default; b=eHhaq2RcXXWxcoPXADeICYGOw+HWby/
	7BZSBUKwSL0byLDVILA5pcBq89ltDxFwVilLx+f/H5BcOK9awmNGljxa5TDbCiJ2
	VwydcQVmzTOwTSqJKwPZf6dqnqOcvcxJ4GCuLuOV4YjLANc2S9zVYoicxqbywJrD
	duzVQhEz3DFE=
To: linux-kernel@vger.kernel.org
Subject: kernel panic when writing to 32 GB SDHC card
X-PHP-Originating-Script: 501:rcube.php
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jul 2014 16:51:18 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <bafa51d9a669d9c9ae7348dfb3f2d392@admin.virtall.com>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experiencing kernel panics when writing random data (say, rsyncing 
data from a different host) to a SDHC card.
Typically, this happens after 5 mins - 1 hour of such activity.

The trace contains __usb_hdc_giveback_urb, sg_complete, but 
unfortunately I don't have it in text format.

I've uploaded photo captures here:

http://www.virtall.com/files/temp/usb/


Kernels where I saw the panic:

- 3.13.0-32.57 - Ubuntu 14.04 x86 kernel
- 3.15.6 - from kernel.org


Samsung Ativ laptop:

         Manufacturer: SAMSUNG ELECTRONICS CO., LTD.
         Product Name: 905S3G/906S3G/915S3G
         Version: P06RBV

Bus 001 Device 002: ID 0bda:0129 Realtek Semiconductor Corp. RTS5129 
Card Reader Controller



-- 
Tomasz Chmielewski
http://www.sslrack.com

