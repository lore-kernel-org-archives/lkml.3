Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3GJOIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:08:00 -0400
Received: from relay03.pair.com ([209.68.5.17]:1440 "HELO relay03.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754046Ab3GJOH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:07:59 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2013 10:07:59 EDT
X-pair-Authenticated: 70.112.99.80
Message-ID: <51DD692B.70909@tabi.org>
Date: Wed, 10 Jul 2013 09:01:15 -0500
From: Timur Tabi <timur@tabi.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19
MIME-Version: 1.0
To: Alexander Popov <a13xp0p0v88@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Chris Ball <cjb@laptop.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V2 2/2] powerpc/512x: add LocalPlus Bus FIFO device driver
References: <1373451678-20065-1-git-send-email-a13xp0p0v88@gmail.com> <20130710134624.GC2615@book.gsilab.sittig.org>
In-Reply-To: <20130710134624.GC2615@book.gsilab.sittig.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Sittig wrote:
>> >+ * Author is Alexander Popov<a13xp0p0v88@gmail.com>.

> nit pick:  is 1337 speak usual and appropriate here?

Um, that's his actual email address.

> shouldn't headers get sorted alphabetically?

Is that a new policy?  I've never heard that requirement.

>> +MODULE_AUTHOR("Alexander Popov <a13xp0p0v88@gmail.com>");
>> +MODULE_DESCRIPTION("MPC512x LocalPlus FIFO device driver");
>> +MODULE_LICENSE("GPL");
>
> aren't these usually at the end of the source for quick lookup?

Yes, and it should be "GPL v2" also.

-- 
Timur Tabi
