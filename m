Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbaJaUuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:50:39 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:51825 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaJaUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:50:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: at91: rm9200 add system timer resources to watchdog
Date: Fri, 31 Oct 2014 21:50:05 +0100
Message-ID: <3170633.12AsIiHlY5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1414788359-15759-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DNcs1BQS59N82dxl4zmamL0fRTHvO+87oVwIzSbNfxa
 TLgJyzVTqXnbEYVLL6jkf0euNo/IpWVOiEcrUfk7SH423NoVzl
 rNKzYe/enAtRJQ5S/4ymOgp+vLOVbGmjnDqgKfG5zCE7GtFU4r
 6TZQNT8SSSgoFOfybGVKLac4ODICy5ug7PL75dFPTLgTb0vGsL
 b4wH8+ZekFtxT3aArTTIZB3U91WLmayNq18GecoEOzE1t7g/F1
 uO/wii8yBJx/OH1HpC+NcVi5ZvvBdzTQEH0QPp4VhIbdWN9zl6
 sOdGwRupPQpRIYnxOAAO9nKmd/noF5vVOGEZTDwTzKi8k6ScbA
 dI83C4aP2cnjMlgIqeMc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2014 21:45:58 Alexandre Belloni wrote:
> To be able to make the watchdog driver independent from the mach/ includes, pass
> the system timer register space as a resource.
> 
> Also, change the name to avoid conflicting with the at91sam9 watchdog driver.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 

Doing this change as a separate patch breaks bisection because now the device
name no longer matches untile the other patch is applied too.

	Arnd
