Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3CKQVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:21:11 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:37841 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320Ab3CKQVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:21:09 -0400
Message-ID: <513E0471.6@semaphore.gr>
Date: Mon, 11 Mar 2013 18:21:05 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 linux-next] cpufreq: conservative: Use an inline function
 to evaluate freq_target
References: <51366C77.3080309@semaphore.gr> <CAKohpokdG2vd5Cp4Lmcnc5ZrLsa-_4Kcy-DvLjG--6SMVsGZkg@mail.gmail.com> <51374F8D.9040300@semaphore.gr> <CAKohponZrMyZkUBDAnMv=B+fVpqYdQ62bP2iQGsg1=uOKfyPdQ@mail.gmail.com>
In-Reply-To: <CAKohponZrMyZkUBDAnMv=B+fVpqYdQ62bP2iQGsg1=uOKfyPdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 6 March 2013 22:15, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> Use an inline function to evaluate freq_target to avoid duplicate code.
>>
>> Also, define a macro for the default frequency step.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>   drivers/cpufreq/cpufreq_conservative.c | 27 +++++++++++++++------------
>>   1 file changed, 15 insertions(+), 12 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Hi Rafael,

Could you please let me know if this patchset is going to be 
applied or not?

Thank you in advance for your time,
Stratos
