Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231Ab3IFG6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:58:48 -0400
Received: from mail.peak-system.com ([213.157.13.214]:45996 "EHLO
	mail.peak-system.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3IFG6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:58:46 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2013 02:58:46 EDT
Message-ID: <52297D15.9040108@peak-system.com>
Date: Fri, 06 Sep 2013 08:58:29 +0200
From: Stephane Grosjean <s.grosjean@peak-system.com>
Reply-To: Stephane Grosjean <s.grosjean@peak-system.com>
Organization: PEAK-System
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0)
 Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] can: pcan_usb_core: fix memory leak on failure paths in
 peak_usb_start()
References: <1378450379823688500@peak-system.com>
 <52297C8E.70101@pengutronix.de>
In-Reply-To: <52297C8E.70101@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AxigenSpam-Level: 1
X-CTCH-RefID: str=0001.0A0C0209.52297D24.01AB,ss=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-AXIGEN-KAS-Info: Not spam
X-AXIGEN-KAS-Info: Version: 4.4.2 (May 20 2011 12:01:19)
X-AXIGEN-KAS-Info: Envelope from: 
X-AXIGEN-KAS-Info: Rate: 0
X-AXIGEN-KAS-Info: Status: not_detected
X-AXIGEN-KAS-Info: Method: none
X-AXIGEN-KAS-Info: DBG v.5. 1818, 81. R:128,1,128,6,7,128,128,128,0.
 M:4,24,145,160,173,193,194, CF:0,76,1. Date: +0200
X-AXIGEN-KAS-Spam-Level: Not Spam
X-AXIGEN-KAS-Spam-Confidence: 0%
X-AxigenVirus-Level: 1
X-AXIGEN-KAV-Info: clean: Scanned with Kaspersky Anti Virus 8.0.3.83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 06/09/2013 08:56, Marc Kleine-Budde a écrit :
> On 09/06/2013 08:52 AM, Stephane Grosjean wrote:
>> Tx and rx urbs are not deallocated if something goes wrong in peak_usb_start().
>> The patch fixes error handling to deallocate all the resources.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
> Tnx,
> Marc
>
> BTW: A simply reply to the original patch with your Acked-by is sufficient.
>

Ok, thx Marc. I keep it in mind for the next time (if any ;-))

Stéphane
--
PEAK-System Technik GmbH, Otto-Roehm-Strasse 69, D-64293 Darmstadt 
Geschaeftsleitung: A.Gach/U.Wilhelm,St.Nr.:007/241/13586 FA Darmstadt 
HRB-9183 Darmstadt, Ust.IdNr.:DE 202220078, WEE-Reg.-Nr.: DE39305391 
Tel.+49 (0)6151-817320 / Fax:+49 (0)6151-817329, info@peak-system.com
