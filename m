Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaAAERo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 31 Dec 2013 23:17:44 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62473 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaAAERn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 23:17:43 -0500
Message-ID: <52C396E3.5080000@landley.net>
Date: Tue, 31 Dec 2013 22:17:39 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Question about /proc/uptime
References: <1388025009.1176.17@driftwood>	<20131227144504.GA17192@redhat.com>	<20131230095656.4c78dd98@mschwide>	<20131230151110.GA29636@redhat.com> <20131230162617.1b013251@mschwide>
In-Reply-To: <20131230162617.1b013251@mschwide>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/13 09:26, Martin Schwidefsky wrote:
> On Mon, 30 Dec 2013 16:11:10 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>> Not sure I understand... except that timekeeping_resume() does
>> __timekeeping_inject_sleeptime().
>
> Hmm, you are right. The sleeptime is added to the monotonic boottime.
> So the first value of /proc/uptime is the wall-time since boot.
> And the second value is combined idle time over all cpus.

Is there an obvious way to query the non-suspend uptime from userspace?

Rob
