Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423066Ab3CVU2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:28:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422915Ab3CVU2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:28:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/5] ARM: ux500: Add machine support for ccu8540
Date: Fri, 22 Mar 2013 20:28:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, Alexander Shiyan <shc_work@mail.ru>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org> <20130322172346.GG4977@n2100.arm.linux.org.uk> <20130322172911.GH4977@n2100.arm.linux.org.uk>
In-Reply-To: <20130322172911.GH4977@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303222028.14953.arnd@arndb.de>
X-Provags-ID: V02:K0:QzuOojqm/9KVZyOjnYSgiX6H2rlGXF/JOiXRKsPOa8A
 rRzQqwDKJiPcPm6ZdeX5kIwgCV5UXKF99kAf0pbyA3yngv9p6i
 8oGq8B+gW5kagATMF8tMqlMgae3kp7I1WfzKy3roX1zow+RdGx
 ZOn7I2qWtst+03JT4owUbjszzfkWSHjhAa4X3FgWK4VtreMVdw
 sx7Rx1EHhSXWxLmmOe2hc+83sjkqpiGzzo+2/5MfJEe1oX1ZxF
 fCUtyo0pGW8mLYj+Me1mIbCi8ZWxTYmBQQu3ExbA8h3sYMdo2S
 gkXAcXsNsbNbUhf2iJa2C7NeBAMiPMBcJkT7QYSCD6iH1zmdQa
 4HwZgaz8WRLXdUckz6/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 March 2013, Russell King - ARM Linux wrote:
> As I've said before, do not remove entries from this file because
> they will get replaced when it gets updated from the website version.

Sorry about that. For some reason when I merged those patches, I thought
your script would automatically remove entries that are no longer used
in the kernel.

	Arnd
