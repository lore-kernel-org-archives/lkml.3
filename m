Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3CIMAL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 07:00:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38999 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3CIMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 07:00:08 -0500
Message-ID: <513B243F.8020706@tremplin-utc.net>
Date: Sat, 09 Mar 2013 12:59:59 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <matthew.garrett@nebula.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
References: <s5h4ngz56yg.wl%tiwai@suse.de> <5135DBD5.1070702@tremplin-utc.net> <1362498177.7780.13.camel@x230> <s5hk3plu9yc.wl%tiwai@suse.de> <CAKocOOMNgGxwoqxKCrvO_46vLALdjaDMHLeRyFZZ2veNgyJO2g@mail.gmail.com>
In-Reply-To: <CAKocOOMNgGxwoqxKCrvO_46vLALdjaDMHLeRyFZZ2veNgyJO2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-03-13 23:59, Shuah Khan wrote:
:
> Should this be tagged for stables releases? This patch went into suse
> git and just checking to see if it should go into stable releases.
Hello,
This patch will make the module automatically load on some new HP 
laptops. So although it's not fixing a bug, it will extend hardware 
support (a very little bit), which can be considered material for stable 
trees, indeed.

Cheers,
Éric

