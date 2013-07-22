Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3GVUHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:07:36 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46520 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab3GVUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:07:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
References: <CAO4LoOyW39zCnGq_fnQ5LK9sXD8s3x9LdYvvRMZ=AwfoyaOHqw@mail.gmail.com>
Date: Mon, 22 Jul 2013 22:07:34 +0200
Message-ID: <CAAfyv36tJ3bF-uTTd8yqs-4eCJUV6Pz9Acz3pD-VESwTBrSHOQ@mail.gmail.com>
Subject: Re: Unsupported DisplayLink (udl or udlfb module)
From: Belisko Marek <marek.belisko@gmail.com>
To: Paolo Bolzoni <paolo.bolzoni.brown@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Paolo Bolzini,

On Mon, Jul 22, 2013 at 2:58 PM, Paolo Bolzoni
<paolo.bolzoni.brown@gmail.com> wrote:
> Dear kernel list,
> I bought a DVI to VGA adapter[0] hoping to make it work with the
> modules udl or udlfb. The program lsusb does recognize it as a
> DisplayLink:
>
> //// lsmod output:
> Bus 002 Device 004: ID 17e9:4300 DisplayLink
>
> But, it does not matter what of the two modules I have loaded it
> seems the kernel does not recognize it
Matching is done by VID = 0x17e9 which seem match but then by
bInterfaceClass = 0xff, bInterfaceSubClass = 0x00 and bInterfaceProtocol = 0x00.
Can you please post lsusb -v to check what are other parameters for your device.
>
> # modprobe udl
> //// plugging
> # dmesg|tail -3
> [ 5500.731973] usb 2-1: new SuperSpeed USB device number 5 using xhci_hcd
> [ 5500.747190] usbip-host 2-1:1.0: 2-1 is not in match_busid table... skip!
> [ 5500.747760] usbip-host 2-1:1.1: 2-1 is not in match_busid table... skip!
> //// unplugging
> # rmmod udl
> # modprobe udlfb
> //// plugging
> # dmesg|tail -4
> [ 5544.168599] usb 2-1: USB disconnect, device number 5
> [ 5560.144758] usb 2-1: new SuperSpeed USB device number 6 using xhci_hcd
> [ 5560.160033] usbip-host 2-1:1.0: 2-1 is not in match_busid table... skip!
> [ 5560.160585] usbip-host 2-1:1.1: 2-1 is not in match_busid table... skip!
>
> I tried seeking on the Internet, but I could not find anything about
> this 17e9:4300 model. So I ask, it will be supported? It is already
> supported somewhat? Can I help? I have no experience in kernel
> programming; but asking is legit I guess.
>
> Please if you answer put my address paolo.bolzoni.brown@gmail.com in
> CC as I did not register to the mailing list scared by the huge volume.
>
> Yours sincerely,
> Paolo Bolzoni
>
>
> [0] http://www.amazon.co.uk/exec/obidos/ASIN/B0086359SG/ref=ox_ya_os_product
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Regards,

marek

--
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
