Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaCFV7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:59:31 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:38448 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaCFV73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:59:29 -0500
X-AuditID: cbfec37d-b7f616d0000059df-bd-5318efc0477a
Message-id: <5318EFBD.6080803@samsung.com>
Date: Thu, 06 Mar 2014 14:59:25 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Valentina Manea <valentina.manea.m@gmail.com>, gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        ihadzic@research.bell-labs.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        firefly@lists.rosedu.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 09/12] staging: usbip: userspace: remove class device
 infrastructure in vhci_driver
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
 <1393960252-21247-10-git-send-email-valentina.manea.m@gmail.com>
In-reply-to: <1393960252-21247-10-git-send-email-valentina.manea.m@gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+wr+6B9xLBBp/PK1vsOfOL3aJ5rbjF
	qx0vWCyaF69ns7hwN9Li8q45bBaLlrUyWzy7lmOx5+k7Fot3l+ayO3B5LLlwh8nj3r7DLB7n
	22ezeOycdZfdY//cNewe99o2M3o8XXaD0ePzJrkAjigum5TUnMyy1CJ9uwSujEUr3rAUnGGt
	2HrlDHsD4zGWLkZODgkBE4nLh9qYIGwxiQv31rN1MXJxCAksY5S413iEHcLpZZLYfvUGK4Sz
	gVHizrXlYO28AloSv/r/gNksAqoSM/fdArPZBNQlPr/ewQ5iCwnISTQtWc0MYosKREi8OjsR
	qldQ4sfke2C2iICvxP8JuxlBFjAL/GeUmHZjDyNIQlggU2JmYzfUGX2MEu8f9bKCJDiBOu4c
	vANWxCxgLbFy0jYoW15i85q3zBCblSX+XD4F9ZyCxI2Fy1gnMIrMQrJ8FpL2WUjaFzAyr2IU
	Ky1OLihOSk+tMNErTswtLs1L10vOz93ECInC2h2M97/aHGIU4GBU4uHtWCQRLMSaWFZcmXuI
	UYKDWUmE1/QlUIg3JbGyKrUoP76oNCe1+BAjEwenVANj5jRHKffdAZcsWay1G2ctkbsy8+fS
	OwJPFi0tVfk3rc9j/auTKqXmFfuuSBnPOTd58X7lWb/WWT3eeke3LneOngJ/4ZbgP3a2/+zP
	rD+prysqkpwenHRsWvPlkwfe8jH4rC05piJRO/2Ro1nxt/Xdu/mmlz0MfeKy8c2POYy/Hh/j
	Mj+id3HpdSWW4oxEQy3mouJEAPI6v5agAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 12:10 PM, Valentina Manea wrote:
> The class device lists were used only when being initialized,
> being populated and being destroyed. They had no real meaning
> and thus the code was useless.
>
> Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
> ---
>   .../staging/usbip/userspace/libsrc/vhci_driver.c   | 178 ---------------------
>   .../staging/usbip/userspace/libsrc/vhci_driver.h   |   4 -
>   2 files changed, 182 deletions(-)
>


After these changes, is there a need for struct usbip_class_device ??

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
