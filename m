Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaHDDVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:21:36 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60019 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaHDDVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:21:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVg8aaio0OGrGwgxN1hixNkCTJ3xYQBjSq=34Zf=8SBnKw@mail.gmail.com>
References: <53DCE329.4030106@xs4all.nl>
	<CAPDOMVg8aaio0OGrGwgxN1hixNkCTJ3xYQBjSq=34Zf=8SBnKw@mail.gmail.com>
Date: Sun, 3 Aug 2014 23:21:33 -0400
Message-ID: <CAPDOMVhsDn4cewdZr9TQ=o-q9ok6CA0zDaML_0CgtHQ4-GdYJw@mail.gmail.com>
Subject: Re: 3.15.6 USB issue with pwc cam
From: Nick Krause <xerofoify@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 3, 2014 at 3:59 PM, Nick Krause <xerofoify@gmail.com> wrote:
> On Sat, Aug 2, 2014 at 9:10 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>> Hello,
>>
>> I moved a PWC webcam to a USB3 port, and this happened:
>>
>> [53008.911811] usb 5-2: new full-speed USB device number 2 using xhci_hcd
>> [53009.213504] usb 5-2: New USB device found, idVendor=0471, idProduct=0311
>> [53009.213514] usb 5-2: New USB device strings: Mfr=0, Product=0,
>> SerialNumber=1
>> [53009.213519] usb 5-2: SerialNumber: 01690000A5000000
>> [53009.215547] pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II)
>> USB webcam detected.
>> [53009.846698] pwc: Registered as video0.
>> [53009.846814] input: PWC snapshot button as
>> /devices/pci0000:00/0000:00:07.0/0000:02:00.0/usb5/5-2/input/input7
>> [53009.847233] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53009.847242] usb 5-2: Not enough bandwidth for altsetting 1
>> [53009.847275] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53009.847285] usb 5-2: Not enough bandwidth for altsetting 2
>> [53009.847317] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53009.847323] usb 5-2: Not enough bandwidth for altsetting 3
>> [53009.847355] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53009.847360] usb 5-2: Not enough bandwidth for altsetting 4
>> [53010.004876] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.004890] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.004896] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.004960] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.004988] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.004992] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.005066] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.005075] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.005079] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.005530] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.005540] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.005544] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.006438] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.006446] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.006450] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.007453] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.007461] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.007465] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.007567] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.007574] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.007578] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.007681] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.007689] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.007695] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.008126] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.008135] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.008140] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.008798] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.008808] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.008812] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.009576] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.009583] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.009588] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.009680] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.009689] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.009697] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.009978] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.009986] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.009990] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.010705] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.010716] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.010725] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.011350] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.011360] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.011366] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.012643] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.012655] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.012660] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.012758] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.012766] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.012771] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.013017] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.013025] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.013031] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.013793] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.013798] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.013803] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.014096] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.014102] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.014106] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.025999] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026007] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026010] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026072] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026075] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026077] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026119] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026122] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026125] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026388] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026392] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026393] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026588] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026591] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026592] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026872] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026876] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026878] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026908] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026911] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026912] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.026949] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.026951] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.026952] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.027119] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.027121] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.027122] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.027279] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.027281] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.027283] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.027550] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.027554] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.027556] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.027594] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.027597] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.027598] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.027675] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.027677] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.027679] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.027870] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.027874] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.027876] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.028157] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.028161] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.028163] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.028662] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.028666] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.028668] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.028709] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.028711] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.028713] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.028794] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.028797] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.028799] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.029075] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.029078] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.029079] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.029439] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.029442] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.029444] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038066] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038073] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038075] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038107] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038110] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038111] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038148] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038151] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038153] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038437] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038441] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038443] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038617] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038620] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038621] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038890] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038894] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038896] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038928] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038930] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038932] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.038964] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.038966] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.038968] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.039140] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.039142] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.039144] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.039296] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.039299] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.039300] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.039598] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.039601] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.039603] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.039654] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.039657] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.039658] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.039772] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.039775] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.039777] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.040044] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.040049] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.040051] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.040331] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.040334] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.040336] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.040838] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.040841] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.040843] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.040884] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.040886] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.040888] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.040971] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.040973] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.040975] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.041207] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.041209] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.041211] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.041450] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.041454] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.041455] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.050772] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.050788] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.050791] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.050825] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.050837] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.050839] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.050879] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.050882] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.050884] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.051166] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.051170] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.051172] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.051408] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.051412] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.051414] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.051805] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.051809] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.051811] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.051842] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.051845] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.051847] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.051880] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.051883] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.051885] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.052174] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.052177] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.052179] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.052390] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.052393] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.052395] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.052783] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.052787] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.052789] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.052887] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.052890] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.052892] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.052982] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.052984] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.052986] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.053262] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.053264] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.053266] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.053556] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.053559] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.053561] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.054205] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.054210] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.054212] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.054256] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.054259] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.054261] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.054355] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.054358] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.054360] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.054612] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.054615] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.054617] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.054845] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.054848] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.054850] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.064272] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.064280] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.064283] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.064320] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.064324] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.064326] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.064369] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.064373] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.064375] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.064694] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.064698] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.064701] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.064921] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.064925] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.064927] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.065241] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.065245] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.065248] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.065281] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.065285] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.065287] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.065330] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.065333] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.065335] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.065611] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.065628] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.065634] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.066072] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.066078] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.066081] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.066528] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.066533] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.066535] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.066590] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.066594] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.066598] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.066707] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.066710] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.066713] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.067095] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.067100] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.067103] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.067457] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.067465] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.067470] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.068139] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.068144] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.068147] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.068230] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.068233] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.068236] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.068350] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.068354] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.068356] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.068659] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.068663] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.068665] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.068980] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.068985] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.068988] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.078360] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.078366] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.078368] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.078398] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.078400] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.078402] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.078498] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.078501] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.078503] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.078770] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.078774] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.078777] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.079011] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.079015] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.079017] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.079321] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.079324] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.079325] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.079356] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.079359] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.079361] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.079394] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.079396] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.079398] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.079661] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.079663] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.079665] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.079820] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.079822] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.079823] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.080214] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.080218] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.080219] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.080264] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.080266] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.080268] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.080355] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.080357] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.080359] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.080561] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.080563] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.080564] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.080746] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.080748] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.080749] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.081155] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.081158] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.081160] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.081197] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.081199] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.081201] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.081274] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.081276] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.081278] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.081470] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.081473] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.081474] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53010.081701] xhci_hcd 0000:02:00.0: ERROR: unexpected command
>> completion code 0x11.
>> [53010.081706] usb 5-2: Not enough bandwidth for altsetting 1
>> [53010.081710] usb 5-2: 2:1: usb_set_interface failed (-22)
>> [53063.286759] ------------[ cut here ]------------
>> [53063.286783] WARNING: CPU: 2 PID: 3282 at
>> drivers/media/v4l2-core/videobuf2-core.c:2011
>> __vb2_queue_cancel+0x102/0x170 [videobuf2_core]()
>> [53063.286786] Modules linked in: bnep bluetooth fuse edac_core
>> cpufreq_userspace nf_conntrack_netbios_ns nf_conntrack_broadcast
>> ip6t_REJECT ipt_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
>> xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4
>> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter
>> ip6_tables ip_tables x_tables eeprom it87 hwmon_vid ext2 ppdev kvm_amd
>> kvm snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi microcode
>> k10temp parport_serial pwc parport_pc videobuf2_vmalloc videobuf2_memops
>> v4l2_common parport videobuf2_core i2c_piix4 snd_hda_codec_realtek
>> videodev evdev cp210x snd_hda_codec_generic snd_hda_intel cdc_acm
>> usbserial snd_hda_controller snd_hda_codec snd_seq snd_seq_device
>> snd_pcm snd_timer snd button acpi_cpufreq nfsd auth_rpcgss oid_registry
>> [53063.286844]  nfs_acl lockd binfmt_misc sunrpc autofs4 hid_generic
>> usbhid radeon fbcon ehci_pci bitblit softcursor ehci_hcd font ohci_pci
>> ohci_hcd cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight sr_mod
>> cdrom drm_kms_helper ttm drm xhci_hcd fb fbdev
>> [53063.286876] CPU: 2 PID: 3282 Comm: skype Not tainted 3.15.6 #5
>> [53063.286879] Hardware name: Gigabyte Technology Co., Ltd. To be filled
>> by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
>> [53063.286882]  0000000000000000 000000001e19c613 ffffffff814f1fd3
>> 0000000000000000
>> [53063.286887]  ffffffff81069fc1 0000000000000000 0000000040045613
>> ffff880316167500
>> [53063.286892]  ffff88042ca30300 ffff8803cf337c48 ffffffffa0446832
>> ffff88042ca30000
>> [53063.286897] Call Trace:
>> [53063.286907]  [<ffffffff814f1fd3>] ? dump_stack+0x4a/0x75
>> [53063.286914]  [<ffffffff81069fc1>] ? warn_slowpath_common+0x81/0xb0
>> [53063.286924]  [<ffffffffa0446832>] ? __vb2_queue_cancel+0x102/0x170
>> [videobuf2_core]
>> [53063.286933]  [<ffffffffa044853d>] ? vb2_internal_streamoff+0x1d/0x50
>> [videobuf2_core]
>> [53063.286944]  [<ffffffffa0423163>] ? __video_do_ioctl+0x2f3/0x380
>> [videodev]
>> [53063.286957]  [<ffffffffa0422bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
>> [53063.286967]  [<ffffffffa0422e70>] ? video_ioctl2+0x10/0x10 [videodev]
>> [53063.286974]  [<ffffffff810bffbb>] ? futex_wait_queue_me+0xdb/0x140
>> [53063.286983]  [<ffffffffa041e7df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
>> [53063.286993]  [<ffffffffa042c7b6>] ? do_video_ioctl+0x246/0x1330
>> [videodev]
>> [53063.286998]  [<ffffffff810c0b9c>] ? futex_wake+0x7c/0x160
>> [53063.287003]  [<ffffffff810c280c>] ? do_futex+0x12c/0xb00
>> [53063.287008]  [<ffffffff814f714e>] ? _raw_spin_unlock_irq+0xe/0x30
>> [53063.287013]  [<ffffffff8108e3be>] ? finish_task_switch+0x3e/0xe0
>> [53063.287022]  [<ffffffffa042d922>] ? v4l2_compat_ioctl32+0x82/0xb8
>> [videodev]
>> [53063.287028]  [<ffffffff81185f32>] ? compat_SyS_ioctl+0x132/0x1120
>> [53063.287034]  [<ffffffff810b5e1d>] ? ktime_get_ts+0x3d/0xd0
>> [53063.287039]  [<ffffffff81085aa8>] ? posix_ktime_get_ts+0x8/0x10
>> [53063.287043]  [<ffffffff81086960>] ? SyS_clock_gettime+0x60/0x80
>> [53063.287049]  [<ffffffff814f9405>] ? cstar_dispatch+0x7/0x1a
>> [53063.287052] ---[ end trace 03072f5e82f277f5 ]---
>> [53063.287055] ------------[ cut here ]------------
>> [53063.287063] WARNING: CPU: 2 PID: 3282 at
>> drivers/media/v4l2-core/videobuf2-core.c:1095
>> vb2_buffer_done+0x17f/0x1a0 [videobuf2_core]()
>> [53063.287066] Modules linked in: bnep bluetooth fuse edac_core
>> cpufreq_userspace nf_conntrack_netbios_ns nf_conntrack_broadcast
>> ip6t_REJECT ipt_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
>> xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4
>> nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip6table_filter
>> ip6_tables ip_tables x_tables eeprom it87 hwmon_vid ext2 ppdev kvm_amd
>> kvm snd_usb_audio snd_usbmidi_lib snd_hwdep snd_rawmidi microcode
>> k10temp parport_serial pwc parport_pc videobuf2_vmalloc videobuf2_memops
>> v4l2_common parport videobuf2_core i2c_piix4 snd_hda_codec_realtek
>> videodev evdev cp210x snd_hda_codec_generic snd_hda_intel cdc_acm
>> usbserial snd_hda_controller snd_hda_codec snd_seq snd_seq_device
>> snd_pcm snd_timer snd button acpi_cpufreq nfsd auth_rpcgss oid_registry
>> [53063.287118]  nfs_acl lockd binfmt_misc sunrpc autofs4 hid_generic
>> usbhid radeon fbcon ehci_pci bitblit softcursor ehci_hcd font ohci_pci
>> ohci_hcd cfbfillrect cfbimgblt cfbcopyarea i2c_algo_bit backlight sr_mod
>> cdrom drm_kms_helper ttm drm xhci_hcd fb fbdev
>> [53063.287143] CPU: 2 PID: 3282 Comm: skype Tainted: G        W
>> 3.15.6 #5
>> [53063.287146] Hardware name: Gigabyte Technology Co., Ltd. To be filled
>> by O.E.M./F2A85X-UP4, BIOS F5a 04/30/2013
>> [53063.287148]  0000000000000000 000000001e19c613 ffffffff814f1fd3
>> 0000000000000000
>> [53063.287153]  ffffffff81069fc1 0000000000000000 ffff88040cc27c00
>> ffff88042ca30300
>> [53063.287157]  0000000000000003 ffff8803cf337c48 ffffffffa04460af
>> 0000000000000000
>> [53063.287161] Call Trace:
>> [53063.287167]  [<ffffffff814f1fd3>] ? dump_stack+0x4a/0x75
>> [53063.287172]  [<ffffffff81069fc1>] ? warn_slowpath_common+0x81/0xb0
>> [53063.287181]  [<ffffffffa04460af>] ? vb2_buffer_done+0x17f/0x1a0
>> [videobuf2_core]
>> [53063.287189]  [<ffffffffa044686e>] ? __vb2_queue_cancel+0x13e/0x170
>> [videobuf2_core]
>> [53063.287197]  [<ffffffffa044853d>] ?f+0x1d/0x50
>> [videobuf2_core] vb2_internal_streamof
>> [53063.287207]  [<ffffffffa0423163>] ? __video_do_ioctl+0x2f3/0x380
>> [videodev]
>> [53063.287219]  [<ffffffffa0422bc0>] ? video_usercopy+0x1f0/0x490 [videodev]
>> [53063.287229]  [<ffffffffa0422e70>] ? video_ioctl2+0x10/0x10 [videodev]
>> [53063.287234]  [<ffffffff810bffbb>] ? futex_wait_queue_me+0xdb/0x140
>> [53063.287244]  [<ffffffffa041e7df>] ? v4l2_ioctl+0x11f/0x160 [videodev]
>> [53063.287253]  [<ffffffffa042c7b6>] ? do_video_ioctl+0x246/0x1330
>> [videodev]
>> [53063.287259]  [<ffffffff810c0b9c>] ? futex_wake+0x7c/0x160
>> [53063.287263]  [<ffffffff810c280c>] ? do_futex+0x12c/0xb00
>> [53063.287268]  [<ffffffff814f714e>] ? _raw_spin_unlock_irq+0xe/0x30
>> [53063.287272]  [<ffffffff8108e3be>] ? finish_task_switch+0x3e/0xe0
>> [53063.287281]  [<ffffffffa042d922>] ? v4l2_compat_ioctl32+0x82/0xb8
>> [videodev]
>> [53063.287286]  [<ffffffff81185f32>] ? compat_SyS_ioctl+0x132/0x1120
>> [53063.287291]  [<ffffffff810b5e1d>] ? ktime_get_ts+0x3d/0xd0
>> [53063.287295]  [<ffffffff81085aa8>] ? posix_ktime_get_ts+0x8/0x10
>> [53063.287299]  [<ffffffff81086960>] ? SyS_clock_gettime+0x60/0x80
>> [53063.287305]  [<ffffffff814f9405>] ? cstar_dispatch+0x7/0x1a
>> [53063.287308] ---[ end trace 03072f5e82f277f6 ]---
>>
>>
>>
>> At the end I checked the video settings in skype.
>> What went wrong?
>> How to fix?
>>
>>
>> Kind regards,
>> Udo
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Udo,
> I am adding the mailing list as there are people who are experts in
> this part of the kernel who
> known more then me. I am going to explain my trace of this to you and
> add it below for
> the other developers to read about the issue here.
>
> 1.  The first part of the trace is going to vb2_internal_streamoff and
> in this function we are calling the second function
> of the trace which is vb2_buffer_done.
> 2. In function ,vb2_buffer_done we have a few WARN ONS and now to we
> need to find the correct one
> 3. Since we are calling the function with the state,
> VB2_BUF_STATE_ERROR  we are tracked to the first
> if statement here as we are not streaming at this point
>
> if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
>  return;
> We will hit your warn on and print out your message. This seems to be
> correct at least to me but let's see what the other developers state
> about my trace.
>
> As for the other developers on the list seems to a miswritten call
> before be are streaming this queue of data and I would recommend
> moving the lines
>
> q->streaming = 0;
> q->start_streaming_called = 0;
> q->queued_count = 0;
> before the for loop that calls vb2_buffer_done inside it's self. I am
> not sure if this is a correct fix through as I am new but if it is I
> will write the patch
> and sent it to the usb mailing list.
> Regards Nick

I am sending you my patch through email so you can see my change.If
you want to test in on a kernel tree , use a recent kernel and patch
it .  I don't remember off the top of my head if patch works with
gitpatches sent by email but if it doesn't just use git am on torvalds
git by cloning it with the command, git clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
linux-git and cd to linux-git
and apply using git am after running git add -f filename I am sending
you. After you can compile the kernel and see if you get a error
and my trace is wrong.
Sorry about the instructions and Regards,
Nick
