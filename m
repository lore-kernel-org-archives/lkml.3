Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaFDBbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:31:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:12026 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750723AbaFDBbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:31:01 -0400
X-IronPort-AV: E=Sophos;i="4.98,969,1392134400"; 
   d="scan'208";a="31413105"
Message-ID: <538E77E4.8010406@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 09:35:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: <josh@joshtriplett.org>, Joe Perches <joe@perches.com>,
        <linux-kernel@vger.kernel.org>, <mingo@kernel.org>,
        <dipankar@in.ibm.com>, <akpm@linux-foundation.org>,
        <mathieu.desnoyers@efficios.com>, <niv@us.ibm.com>,
        <tglx@linutronix.de>, <peterz@infradead.org>, <rostedt@goodmis.org>,
        <dhowells@redhat.com>, <edumazet@google.com>, <dvhart@linux.intel.com>,
        <fweisbec@gmail.com>, <oleg@redhat.com>, <sbw@mit.edu>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com> <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud> <1401731968.7323.4.camel@joe-AO725> <20140602181658.GX22231@linux.vnet.ibm.com> <20140602185635.GB13569@cloud> <20140602190821.GZ22231@linux.vnet.ibm.com> <20140602191155.GB13648@cloud> <20140602192729.GB22231@linux.vnet.ibm.com>
In-Reply-To: <20140602192729.GB22231@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 03:27 AM, Paul E. McKenney wrote:
> On Mon, Jun 02, 2014 at 12:11:55PM -0700, josh@joshtriplett.org wrote:
>> On Mon, Jun 02, 2014 at 12:08:21PM -0700, Paul E. McKenney wrote:
>>> On Mon, Jun 02, 2014 at 11:56:35AM -0700, josh@joshtriplett.org wrote:
>>>> On Mon, Jun 02, 2014 at 11:16:58AM -0700, Paul E. McKenney wrote:
>>>>> On Mon, Jun 02, 2014 at 10:59:28AM -0700, Joe Perches wrote:
>>>>>> On Mon, 2014-06-02 at 10:48 -0700, josh@joshtriplett.org wrote:
>>>>>>> On Mon, Jun 02, 2014 at 10:22:58AM -0700, Joe Perches wrote:
>>>>>>>> On Mon, 2014-06-02 at 10:00 -0700, Paul E. McKenney wrote:
>>>>>>>>> A ksummit-discuss email thread looked at the difficulty recruiting
>>>>>>>>> and retaining reviewers.
>>>>>>>>
>>>>>>>> []
>>>>>>>>
>>>>>>>>> Paul Walmsley also noted the need for patch
>>>>>>>>> submitters to know who the key reviewers are and suggested adding an
>>>>>>>>> "R:" tag to the MAINTAINERS file to record this information on a
>>>>>>>>> per-subsystem basis.
>>>>>>>>
>>>>>>>> I'm not sure of the value of this.
>>>>>>>>
>>>>>>>> Why not just mark the actual reviewers as maintainers?
>>>>>>>
>>>>>>> As discussed in the kernel summit discussion, being a regular patch
>>>>>>> reviewer isn't the same thing as being *the* maintainer.
>>>>>>
>>>>>> I think it's not particularly important or valuable
>>>>>> here to make that distinction.
>>>>>>
>>>>>> What real difference does it make?
>>>>>
>>>>> In the particular case of Josh, none, at least from my viewpoint.  He of
>>>>> course might or might not want to take on additional maintainership
>>>>> responsibility at this particular point in time, in which case, I would
>>>>> be more than happy to have him as a designated maintainer.
>>>>
>>>> For the record, I'd be happy to be listed as a co-maintainer for RCU. :)
>>>
>>> I would be happy to put you down as maintainer and Steven down as
>>> official reviewer.  ;-)
>>
>> I'd suggest adding Mathieu Desnoyers, Oleg Nesterov, and Lai Jiangshan
>> as reviewers as well, with their consent.
> 
> Mathieu, Oleg, Lai, any objections?
> 
> 							

I agree to add me.

Thanks,
Lai
