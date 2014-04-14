Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaDNQqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:46:02 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:50606 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaDNQp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:45:56 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 12:45:56 EDT
X-ME-Helo: PCombes.localdomain
X-ME-Auth: cGFzY29tQHdhbmFkb28uZnI=
X-ME-Date: Mon, 14 Apr 2014 18:38:03 +0200
X-ME-IP: 82.124.119.218
Message-ID: <534C0EE3.6080308@orange.fr>
Date: Mon, 14 Apr 2014 18:37:55 +0200
From: Pascal COMBES <pascom@orange.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <dev@robertfoss.se>
Subject: Re: [PATCH v2 2/3] Fix coding style problem (cast with space) in
 drivers/staging/crystalhd/crystalhd_lnx.c
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>	 <534AE1D6.1040304@orange.fr> <1397424990.31896.10.camel@x220>
In-Reply-To: <1397424990.31896.10.camel@x220>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/04/2014 23:36, Paul Bolle a écrit :
> On Sun, 2014-04-13 at 21:13 +0200, Pascal COMBES wrote:
>> From: Pascal COMBES <pascom@orange.fr>
>>
>> Fix coding style problem in drivers/staging/crystalhd/crystalhd_lnx.c:
>> No space needed before a cast.
>>
>> Signed-off-by: Pascal COMBES <pascom@orange.fr>
>> ---
>> diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
>> index fd7f08a..15e8f02 100644
>> --- a/drivers/staging/crystalhd/crystalhd_lnx.c
>> +++ b/drivers/staging/crystalhd/crystalhd_lnx.c
>> @@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
>>  
>>  static irqreturn_t chd_dec_isr(int irq, void *arg)
>>  {
>> -	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
>> +	struct crystalhd_adp *adp = (struct crystalhd_adp *)arg;
> 
> Shouldn't this cast just be dropped instead?

I think as you and was wondering why it was there but I didn't dare
removing it. I considered it was not really coding style.
But after second thought, I will remove it when I resend tomrorrow.
	Regards,
Pascal COMBES.
> 
>>  	int rc = 0;
>>  	if (adp)
>>  		rc = crystalhd_cmd_interrupt(&adp->cmds);
>>
> 
> 
> Paul Bolle
> 
> 

