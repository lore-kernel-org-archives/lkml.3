Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3AUVWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:22:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55156 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912Ab3AUVWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:22:08 -0500
Message-ID: <50FDB162.2040209@zytor.com>
Date: Mon, 21 Jan 2013 15:21:38 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ellwood Blues <elwood.blue@gmail.com>
CC: linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: 2TB USB hard drive for backing up
References: <jmunm9$90r$2@speranza.aioe.org> <201204301814.21525.Martin@lichtvoll.de> <CAGZeNoc82T0jS=Sg3d2umqi6PjAWjOKjqK2RbuK+QfAzN3Pmww@mail.gmail.com> <201205010044.24643.Martin@lichtvoll.de> <CAGZeNoeSEtTMK22+JcsG7xRRrbsQwgJV5iLgWenrX=rvLr-ZXQ@mail.gmail.com> <CAGZeNof6NWiXhCDPpZiLu8QhQ_6Cmp-nhSOf=h=-jAjccWaa7g@mail.gmail.com> <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
In-Reply-To: <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2013 03:40 PM, Ellwood Blues wrote:
> Hi.
> 
> I've had this problem for so long that today after compiling kernel
> 3.7.3 and not getting any improvements I decided to let you know that
> some of us still only able to use our GPT 3TB hard disks only on
> Windows.
> 
> On linux only hdparm and gdisk see 3TB but also see some kind of
> corruption on the alternate GPT which is not true because on windows
> works flawlessly.
> 
> I hope you won't take too long to make it work because this is the
> only reason I still loging in on windows, before buying this disk I
> didn't log in on windows at all.
> 
> I don't need the EFI drivers to work because the BIOS is not ready for
> that, I only would like to read and write on the disk which is already
> half full and cannot do any new experiments trying to fix it with
> gdisk.
> 
> I only need the kernel GPT drivers to work out.
> 

This has nothing to do with GPT.  The problem is that the capacity
reported by the drive is truncated:

May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
1565565872 512-byte logical blocks: (801 GB/746 GiB)

Is the hdparm produced via the USB interface or by plugging the internal
drive into an SATA/eSATA port?

Either way... it is offtopic for the linux-efi mailing list.

	-hpa


