Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab3GPSXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:23:39 -0400
Received: from fep23.mx.upcmail.net ([62.179.121.43]:53958 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193Ab3GPSXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:23:37 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <51E58FA5.4000804@odi.ch>
Date: Tue, 16 Jul 2013 20:23:33 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [BUG] 3.10 regression: hang on suspend
References: <51E4501D.3010001@odi.ch> <20130716065626.GA1587@redhat.com> <51E4F790.6090308@odi.ch> <51E51712.4020609@broadcom.com>
In-Reply-To: <51E51712.4020609@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without NetworkManager, no X, on console and with plain jane wpa_supplicant I do
echo mem > /sys/power state

After that, it still responds to keyboard events: I can switch VT and type on 
the consoles, but I can not login on a different VT (pressing Enter after the 
username doesn't return). So I guess tasks have been frozen, but it hangs in 
stopping devices.

settings for pm_test:
devices: same behviour as above
freezer: works as expected (stops tasks; sleeps; resumes tasks)

Nothing in the logs. How can I enable more log?

Ortwin
