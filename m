Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaKDSdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:33:15 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44234 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKDSdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:33:12 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-bf-54591be5d2cb
Message-id: <54591BDF.8060203@samsung.com>
Date: Tue, 04 Nov 2014 19:33:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        pebolle@tiscali.nl, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v3] usb: Remove references to non-existent PLAT_S5P symbol
References: <1412673127-11479-1-git-send-email-s.nawrocki@samsung.com>
 <20141103232438.GA11698@kroah.com>
In-reply-to: <20141103232438.GA11698@kroah.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t/xy7pPpSNDDDob2CyaF69ns7i88BKr
	xeVdc9gsZpzfx2SxaFkrs8WiW2eYHdg89s9dw+7Rt2UVo8fG7U+YPD5vkgtgieKySUnNySxL
	LdK3S+DK6Lv5m7mgl7Wi+bFIA+N0li5GTg4JAROJVw9+M0HYYhIX7q1n62Lk4hASWMooceTJ
	dkaQhJDAJ0aJtZ9NQGxeAS2JZYtfs4LYLAKqEg+3TAQbxCZgKNF7tA+sXlQgQuLk3T3sEPWC
	Ej8m3wOrERHQkHh59BYLyAJmgU5GiaZj58EahAX8JA707GKBWJYt8b61H+wiTgF9iZXfDwDZ
	HEANehL3L2qBhJkF5CU2r3nLPIFRYBaSFbMQqmYhqVrAyLyKUTS1NLmgOCk910ivODG3uDQv
	XS85P3cTIySYv+5gXHrM6hCjAAejEg/viviIECHWxLLiytxDjBIczEoivOqPgUK8KYmVValF
	+fFFpTmpxYcYmTg4pRoYfX4mfDlYauPBvK3phNfUb+p7HmpNP786OF724Yp9698sfxBnJLXJ
	7nbQTa4X3culKj43aS78rf5E5cKp+S/eSKg+3dHSeXJ1edV2V04J6fiLhReUIv4vN3z068Fm
	gw1f3HXF9+RXPd0WcFmsgG114kM/i/XKx7I2HFd4W5m/63Sinv3Zr7uazymxFGckGmoxFxUn
	AgCAHabVRAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/14 00:24, Greg KH wrote:
> On Tue, Oct 07, 2014 at 11:12:07AM +0200, Sylwester Nawrocki wrote:
>> > The PLAT_S5P Kconfig symbol was removed in commit d78c16ccde96
>> > ("ARM: SAMSUNG: Remove remaining legacy code"). There are still
>> > some references left, fix that by replacing them with ARCH_S5PV210.
>> > 
>> > Fixes: d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
>> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> > Acked-by: Jingoo Han <jg1.han@samsung.com>
>> > Cc: <stable@vger.kernel.org>	[3.17+]
>
> This isn't a stable issue...

Sorry for disturbing then, let me go and read the documentation again.

