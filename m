Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbaEFJ4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:56:39 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:55496 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934603AbaEFJ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:56:38 -0400
Date: Tue, 6 May 2014 11:56:35 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: macro@linux-mips.org, John Stultz <john.stultz@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [rtc-linux] Re: X86: Impossible select Enhanced Real Time Clock
 Support (legacy PC RTC driver)
Message-ID: <20140506115635.760827c3@linux.lan.towertech.it>
In-Reply-To: <alpine.LFD.2.11.1405060026210.21408@eddie.linux-mips.org>
References: <1397415946.1555.16.camel@vger.seibold.net>
	<53555C56.1040900@infradead.org>
	<CALAqxLVVGM2nON71BbhuD-7eXnqbKGomfL63COaT7nePuQQ=zg@mail.gmail.com>
	<20140428202034.782de089@linux.lan.towertech.it>
	<alpine.LFD.2.11.1405060026210.21408@eddie.linux-mips.org>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 00:34:41 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  Well, the handling of update-ended interrupts is still missing, as is 
> some non-x86 stuff I posted a fix for recently (still pending review, can 
> you please look into it sometime?).

 Done, sorry for the delay. 

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

