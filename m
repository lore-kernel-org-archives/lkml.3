Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3IZGzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:55:38 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:65197 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3IZGzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <5243D8FA.9090404@suse.cz>
References: <20130926004028.GB9394@localhost>
	<5243D8FA.9090404@suse.cz>
Date: Thu, 26 Sep 2013 14:55:36 +0800
Message-ID: <CAA_GA1d=y31SqLBZGhXXwf3yJnqeTkLW0bNOOV=2mvZ+1C0nHg@mail.gmail.com>
Subject: Re: [munlock] BUG: Bad page map in process killall5 pte:cf17e720 pmd:05a22067
From: Bob Liu <lliubbo@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 2:49 PM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 09/26/2013 02:40 AM, Fengguang Wu wrote:
>> Hi Vlastimil,
>>
>> FYI, this bug seems still not fixed in linux-next 20130925.
>
> Hi,
>
> I sent (including you) a RFC patch and later reviewed patch about week
> ago. I assumed you would test it, but I probably should make that
> request explicit, sorry. Anyway it was added to -mm an hour before your
> mail.
>

Great! And please ignore my noise in this thread.

-- 
Regards,
--Bob
