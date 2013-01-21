Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3AURV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:21:27 -0500
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:43706 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab3AURVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:21:24 -0500
X-Greylist: delayed 5479 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 12:21:24 EST
Message-ID: <50FD637F.2080604@genband.com>
Date: Mon, 21 Jan 2013 09:49:19 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Tom St Denis <tstdenis@elliptictech.com>
CC: Steven Rostedt <rostedt@goodmis.org>, David Dillow <dave@thedillows.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: IPsec AH use of ahash
References: <1161725580.95543.1358782288077.JavaMail.root@elliptictech.com>
In-Reply-To: <1161725580.95543.1358782288077.JavaMail.root@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jan 2013 15:49:20.0950 (UTC) FILETIME=[E0CE3560:01CDF7EE]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19572.000
X-TM-AS-Result: No--9.927900-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 09:31 AM, Tom St Denis wrote:
> ----- Original Message -----
>> From: "Steven Rostedt"<rostedt@goodmis.org> To: "Tom St
>> Denis"<tstdenis@elliptictech.com> Cc: "David
>> Dillow"<dave@thedillows.org>, "Borislav Petkov"<bp@alien8.de>,
>> linux-kernel@vger.kernel.org, netdev@vger.kernel.org Sent: Monday,
>> 21 January, 2013 10:28:33 AM Subject: Re: IPsec AH use of ahash
>>
>> When I send a patch to another maintainer, and they tell me to fix
>> the way I did the comments, I don't complain. I fix the comments
>> and resend.
>
> Which is less of a problem when there is a timeliness factor.  In the
> business world people move on and don't work at that pace.

There can be an impedance mismatch between the "get it done to hit a 
deadline" business world and the "get it right no matter how long it 
takes" world of some open-source projects.

However, many businesses have recognized that they get far more benefit 
from dealing with open-source than it costs them in designer time.

 From the point of view of my employer (I work in telecom) the choices 
are either:

a) work with the kernel to get the code submitted into mainline
b) keep the changes private and port them every time we upgrade

Over a decade or more my management has come to realize that option "a" 
is generally better in the long term, even if it's a bit more effort in 
the short term.

There are exceptions of course, and sometimes we just need to do a 
quick-and-dirty solution to get something out the door.

Chris
