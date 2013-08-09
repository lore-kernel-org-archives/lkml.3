Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab3HIEvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:51:25 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39195 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab3HIEvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:51:23 -0400
Message-ID: <52047540.8050003@linux.vnet.ibm.com>
Date: Fri, 09 Aug 2013 12:51:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [RFC PATCH 00/12] KVM: MMU: locklessly wirte-protect
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <5200F720.7070608@linux.vnet.ibm.com> <5203D785.30506@redhat.com>
In-Reply-To: <5203D785.30506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080904-2674-0000-0000-00000A2A950D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 01:38 AM, Paolo Bonzini wrote:
> Il 06/08/2013 15:16, Xiao Guangrong ha scritto:
>> Hi Gleb, Paolo, Marcelo, Takuya,
>>
>> Any comments or further comments? :)
> 
> It's not the easiest patch to review.  I've looked at it (beyond the
> small comments I have already posted), but it will take some time to
> digest it...

Thanks for your time, Paolo!

> 
> By the way, both I and Gleb will be on vacation next week.  I will read
> email, but I will not be able to apply patches or do pull requests.

Enjoy your vacation. :)

