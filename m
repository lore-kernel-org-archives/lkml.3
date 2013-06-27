Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3F0OiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 10:38:25 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:54288 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab3F0OiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 10:38:24 -0400
Message-ID: <51CC4E5D.10205@lwfinger.net>
Date: Thu, 27 Jun 2013 09:38:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rtl8192cu: slow path warning
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg> <51CB0E9C.50408@lwfinger.net> <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
In-Reply-To: <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 02:33 AM, Richard Genoud wrote:
>
> Yes, of course, you can add my
> Reported-by: Richard Genoud <richard.genoud@gmail.com>
>
> But the patch doesn't compile on my platform ( since I'm on ARM, I
> haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :
>
> ERROR: "rtl_lps_change_work_callback"
> [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!

I was planning on eventually reworking the problem to have only a single 
instance of that INIT_WORK() macro, rather than one for PCI and one for USB. The 
reason for delaying was that that fix would likely be too invasive for 3.10rc7 
or for backporting to stable.

Let me create that patch and I will get you a copy.

Thanks for testing,

Larry


