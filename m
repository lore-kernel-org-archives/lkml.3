Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026Ab3CWMY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 08:24:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35963 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab3CWMY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:24:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: 3.9-rc3+: reports battery as 0 mWh capacity on thinkpad x60
Date: Sat, 23 Mar 2013 13:32:19 +0100
Message-ID: <1364045783.tg02458AIS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130323114011.GA11092@amd.pavel.ucw.cz>
References: <20130323114011.GA11092@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 23, 2013 12:40:12 PM Pavel Machek wrote:
> Hi!
> 
> pavel@amd:~$ cat /proc/acpi/battery/BAT0/info 
> present:                 yes
> design capacity:         0 mWh
> last full capacity:      0 mWh
> battery technology:      rechargeable
> design voltage:          14400 mV
> 
> This worked before... at least it works in 2.6 kernel used by debian.

This works for me in 3.9-rc3.  May I see your .config?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
