Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaKXWMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:12:45 -0500
Received: from mout.web.de ([212.227.17.11]:64609 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaKXWMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:12:43 -0500
Message-ID: <5473AD39.9010309@users.sourceforge.net>
Date: Mon, 24 Nov 2014 23:12:09 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
CC: Corentin Chary <corentin.chary@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Ike Panhc <ike.pan@canonical.com>,
        Jonathan Woithe <jwoithe@just42.net>,
        Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/1] platform: x86: Deletion of checks before backlight_device_unregister()
References: <5307CAA2.8060406@users.sourceforge.net> <5317A59D.4@users.sourceforge.net> <547389A6.9090106@users.sourceforge.net> <3842367.ojrMxTW2rH@path>
In-Reply-To: <3842367.ojrMxTW2rH@path>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:19IZ3BXFZYpgTmq5yqCa53Rlsq7QdZhQDYHGg9JOL6XcKF0XIpL
 0lgEIKajoL3xYXIQWlZsl4JhLDVdZRC4DVvpINaExZgacYVRKKBdnKgLrpkyDrPnHYCeHgf
 LjVlNCqjx+85nxYFSi1gqq72ID8IQsiraUyzx0cJOV+aQAiGqM2f2wx/V5/BSbNckj6AvJH
 jy9K7PCF2QlN1lvDRY79Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This issue was detected by using the Coccinelle software.
> 
> What script was used ?

A semantic patch approach which I published on the mailing lists in March
is in action on my software development system for a while.


> Is it in scripts/coccinelle ?

Not yet.

I hope that the involved update suggestions got sufficient positive feedback
to integrate five scripts there.

Regards,
Markus
