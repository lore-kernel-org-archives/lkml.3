Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3KLV4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:56:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab3KLVzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:55:51 -0500
Message-ID: <5282A3E2.30103@redhat.com>
Date: Tue, 12 Nov 2013 16:55:46 -0500
From: Joe Mario <jmario@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, Michal Marek <mmarek@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 2/2] kallsyms: Revert back to 128 max symbol length
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz> <1384177236-8371-2-git-send-email-mmarek@suse.cz> <20131111141715.GM1962@tassilo.jf.intel.com>
In-Reply-To: <20131111141715.GM1962@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 09:17 AM, Andi Kleen wrote:
> On Mon, Nov 11, 2013 at 02:40:36PM +0100, Michal Marek wrote:
>> This reverts commits
>> f3462aa (Kbuild: Handle longer symbols in kallsyms.c) and
>> eea0e9c (kbuild: Increase kallsyms max symbol length)
>> except for the added overflow check. The reason is a regression caused
>> by increasing the buffer:
>> http://marc.info/?l=linux-kernel&m=138387700415675.
>
> Can you please wait a bit until we tracked down the problem?
>
>
> -Andi
>

Andi:
  Don Zickus and I have been trying to reproduce the problem with
  the config file Fengguang Wu sent to us, but so far have been unsuccessful.

  Given there are 5 other locations in the code that need to be changed
  from [128] to [KSYM_NAME_LEN], and that we still haven't found Fengguang's
  problem yet, I'd be in favor of letting Michal's revert patch 2/2 go forward.

  That would give us time to find the issue Fengguang reported.

Joe  




