Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaBEOfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:35:36 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54447 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBEOff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:35:35 -0500
Date: Wed, 5 Feb 2014 16:35:28 +0200
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: Gene Heskett <gheskett@wdtv.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: possible viri in tarballs?
Message-ID: <20140205163528.5b67d8e0@mdontu-l>
In-Reply-To: <201402050915.34607.gheskett@wdtv.com>
References: <201402050915.34607.gheskett@wdtv.com>
Organization: Home
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 09:15:34 -0500 Gene Heskett wrote:
> I recently brought a daily system scan by clamscan back to life, and
> its emailing me this:
> 
> /home/gene/src/linux-3.8.2/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL
> FOUND /home/gene/src/linux-3.12.6/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL
> FOUND /home/gene/src/linux-3.8.3/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL
> FOUND /home/gene/src/linux-3.12.9/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL
> FOUND /home/gene/src/linux-3.4.36/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL
> FOUND /home/gene/src/linux-3.0.69/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL
> FOUND /home/gene/src/linux-3.2.40/Documentation/usb/gadget_multi.txt:
> MBL_400944.UNOFFICIAL FOUND
> 
> Repeat for several other kernel trees.
> FP or ??

Most likely a FP, but try: https://www.virustotal.com/

-- 
Mihai Donțu
