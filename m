Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3ICJRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:17:47 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48874 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703Ab3ICJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:17:46 -0400
Message-ID: <5225A937.2050507@hitachi.com>
Date: Tue, 03 Sep 2013 18:17:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org
Subject: Re: Re: [RFC PATCH 0/2] Perf support to SDT markers
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903082503.GA20732@gmail.com>
In-Reply-To: <20130903082503.GA20732@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/03 17:25), Ingo Molnar wrote:
> 
> * Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com> wrote:
> 
>> This series adds support to perf to list and probe into the SDT markers.
>> The first patch implements listing of all the SDT markers present in
>> the ELFs (executables or libraries). The SDT markers are present in the
>> .note.stapsdt section of the elf. That section can be traversed to list
>> all the markers. Recognition of markers follows the SystemTap approach.
>>
>> The second patch will allow perf to probe into these markers. This is
>> done by writing the marker name and its offset into the
>> uprobe_events file in the tracing directory.
>> Then, perf tools can be used to analyze perf.data file.
> 
> Please provide a better high level description that explains the history 
> and scope of SDT markers, how SDT markers get into binaries, how they can 
> be used for probing, a real-life usage example that shows something 
> interesting not possible via other ways, etc.

Indeed, and also I'd like to know what versions of SDT this support,
and where we can see the technical document of that. As far as I know,
the previous(?) SDT implementation also involves ugly semaphores.
Have that already gone?

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


