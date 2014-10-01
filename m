Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaJAIJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:09:42 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33220 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaJAIJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140930145055.GA24978@gallifrey>
References: <CAGKO+35+H3MmkaN1m_PfHi0XhbRvtnSBqm3PDmOhs5YBmAZ1jg@mail.gmail.com>
	<20140924201827.GA30643@gallifrey>
	<20140930145055.GA24978@gallifrey>
Date: Wed, 1 Oct 2014 10:09:38 +0200
Message-ID: <CAGKO+365D9Wu2_8HUKjYugTO0+eGGv4rmmHWm4YkygZk5NqC1w@mail.gmail.com>
Subject: Re: 3.16.1 - general protection fault
From: Marcin Gibula <m.gibula@gmail.com>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, I hit something similar:
>>
>> http://www.spinics.net/lists/linux-nfs/msg46047.html 'nfs: disallow duplicate pages in pgio page vectors'
>> http://www.spinics.net/lists/linux-nfs/msg46048.html 'nfs: can_coalesce_requests must enforce contiguity'
>>
>> seem to stop the GPF's/crashes, although there's still something else
>> going on with a corruption I'm seeing every so often.
>
> And that 'something else' seems to be fixed by:
>
> http://marc.info/?l=linux-nfs&m=141208464631105&w=2

Thanks !

-- 
mg
