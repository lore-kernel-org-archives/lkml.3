Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbaJVM1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:27:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932865AbaJVM1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:27:24 -0400
Message-ID: <5447A2A7.2010809@redhat.com>
Date: Wed, 22 Oct 2014 08:27:19 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] x86, kexec: Add .gitignore file
References: <1412981721-3432-1-git-send-email-prarit@redhat.com> <CAKocOOPqeXyzVGztAdAcnBW1gihi8HYAefFJ9k=qT6m-oOPzgQ@mail.gmail.com> <54479FDE.1030502@redhat.com>
In-Reply-To: <54479FDE.1030502@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/22/2014 08:15 AM, Prarit Bhargava wrote:
> 
> 
> On 10/10/2014 07:47 PM, Shuah Khan wrote:
>> On Fri, Oct 10, 2014 at 4:55 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>> When doing git-status there are two untracked files:
>>>
>>> \# Untracked files:
>>> \#   (use "git add <file>..." to include in what will be committed)
>>> \#
>>> \#       arch/x86/purgatory/kexec-purgatory.c
>>> \#       arch/x86/purgatory/purgatory.ro
>>>
>>> Add a .gitignore to block these files.
>>
>> I sent patch for this couple of weeks ago. It is pulled in looks like,
>> I got tipbot
>> for that patch.
>>
>> http://marc.info/?l=linux-kernel&m=141201613309178
> 
> Shuah, I don't see it in tip or linux.

Never mind ... I really need to make sure I do a git pull ;)

4ea48a01bb1a99f4185b77cd90cf962730336cc4

Thanks again Shuah,

P.

> 
> P.
> 
>>
>> -- Shuah
>>
