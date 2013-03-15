Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3COWBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:01:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3COWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:01:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [GIT PULL] clocksource cleanup for 3.10
Date: Fri, 15 Mar 2013 22:01:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <513E38BD.4080407@gmail.com>
In-Reply-To: <513E38BD.4080407@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303152201.44785.arnd@arndb.de>
X-Provags-ID: V02:K0:PYnNiIWiKK7r/FYPmxee26vV7ewlHkxTZfT59JnBPx9
 RN6J9xOvedcaE3Lv3DrT3QCEo3mbpgLi9b40UHCKyfYlkQhKQr
 RhnOFB9kJkdrnTN3knw3j1VGWWUKxy8l2UKeoYp92xbCoMszam
 Qgjn4ezadhrMlZd5GcbJuKCrjpm2mWnwMPgt2uR2FpsbLoKsv8
 Gd7iOuY8BJpNfCZeSfrS/vOGhvanr0uR+UsYHIDOhtXQPky38l
 OzAcS974wHa6yBmNNHPQ1uWsSCNTFn5B7Nyor7b8L64OEIXOWQ
 fJfwi3HmNTMs3awvqoTzRa8yi9HDYwclar1PgALhh01OVZcKG/
 bIgBeANHgb6iWTZgNMJo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013, Rob Herring wrote:
> Please pull. This improves the clocksource init to avoid double matching
> to the DT device node. The clocksource init function changes are needed
> for any other clocksource conversions to CLKSRC_OF, so we need to make
> sure any other conversions use this branch (It happens to silently work
> without warnings, but there would be a mismatch in function ptrs). I'm
> including the twd_smp timer support for CLKSRC_OF here because of the
> dependency on this change.
> 

Pulled into next/cleanup branch, thanks!

	Arnd
