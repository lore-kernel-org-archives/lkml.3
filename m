Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3A2Azx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:55:53 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:49055 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326Ab3A2Azv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:55:51 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 19:55:51 EST
Message-ID: <51071CA0.801@ravellosystems.com>
Date: Tue, 29 Jan 2013 02:49:36 +0200
From: Izik Eidus <izik.eidus@ravellosystems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>, Anton Arapov <anton@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/11] ksm: NUMA trees and page migration
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <20130128155452.16882a6e.akpm@linux-foundation.org>
In-Reply-To: <20130128155452.16882a6e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 01:54 AM, Andrew Morton wrote:
> On Fri, 25 Jan 2013 17:53:10 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
>
>> Here's a KSM series
> Sanity check: do you have a feeling for how useful KSM is?
> Performance/space improvements for typical (or atypical) workloads?
> Are people using it?  Successfully?

Hi,
I think it mostly used for virtualization, I know at least two products 
that it use -
RHEV - RedHat enterprise virtualization, and my current place (Ravello 
Systems) that use it to do vm consolidation on top of cloud enviorments
(Run multiple unmodified VMs on top of one vm you get from ec2 / 
rackspace / what so ever), for Ravello it is highly critical in 
achieving high rate
of consolidation ratio...

>
> IOW, is it justifying itself?

