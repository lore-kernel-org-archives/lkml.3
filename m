Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaETIZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:25:18 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46778 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaETIZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:25:16 -0400
Message-ID: <537B10FB.8050400@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 13:53:23 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pedro Alves <palves@redhat.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com
Subject: Re: [PATCH v2] ptrace: Clarify PTRACE_GETREGSET/PTRACE_SETREGSET,
 documentation in uapi header
References: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com> <53625681.8010905@redhat.com> <53670F35.6010502@linux.vnet.ibm.com> <53725FF6.6060004@redhat.com> <537316DB.4060701@linux.vnet.ibm.com> <53734B7D.4010504@redhat.com>
In-Reply-To: <53734B7D.4010504@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052008-5564-0000-0000-00000DC7F084
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 04:24 PM, Pedro Alves wrote:
> On 05/14/14 08:10, Anshuman Khandual wrote:
>> On 05/13/2014 11:39 PM, Pedro Alves wrote:
>>> On 05/05/14 05:10, Anshuman Khandual wrote:
>>>> On 05/01/2014 07:43 PM, Pedro Alves wrote:
>>> OK, then this is what I suggest instead:
> ...
>>>> Shall I resend the patch with the your proposed changes and your "Signed-off-by" and
>>>> moving myself as "Reported-by" ?
>>>
>>> No idea of the actual policy to follow.  Feel free to do that if that's the
>>> standard procedure.
>>
>> Even I am not sure about this, so to preserve the correct authorship, would you
>> mind sending this patch ?
> 
> Here you go.  This is against current Linus'.  Please take it from
> here if necessary.

Thanks Pedro for the patch. I would assume that the ptrace maintainer (Roland or Oleg as
mentioned in the MAINTAINERS file) will pick it from here and merge mainline. Please do
let me know if the process is otherwise different. Thanks.

