Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3HIRLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:11:37 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:36102 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3HIRLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:11:36 -0400
Message-ID: <52052292.7010205@ahsoftware.de>
Date: Fri, 09 Aug 2013 19:10:42 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: rtc-linux@googlegroups.com, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew de los Reyes <adlr@chromium.org>
Subject: Re: [rtc-linux] Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time:
 enable HID input processing early
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de> <1375382342-25454-2-git-send-email-holler@ahsoftware.de> <20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org> <5204BA2E.8000100@ahsoftware.de> <alpine.LNX.2.00.1308091310490.13089@pobox.suse.cz> <5205170E.9030605@ahsoftware.de> <520519E7.3020807@ahsoftware.de> <CANq1E4TkgKsZcJAygY4k8rwvYMPku_uzWqhcgp+HkfMsb+n84Q@mail.gmail.com>
In-Reply-To: <CANq1E4TkgKsZcJAygY4k8rwvYMPku_uzWqhcgp+HkfMsb+n84Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.08.2013 19:02, schrieb David Herrmann:

> I hope that explains how all this works. I can look over your patch on
> Sunday if still necessary.

Thanks a lot for the explanation. Actually I don't have a problem but 
Andrew Morton asked me some questions I can't answer without looking in 
someone else source. ;)

Fortunately that forced me to enable some debug options which have shown 
a bug Jiri fixed right after I've reported it.

So if your explanation answered Andrew Morton questions, I'm fine, 
because my driver still works as I think it should. ;)

Thanks again,

Alexander Holler

