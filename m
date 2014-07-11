Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaGKQOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:14:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34370 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbaGKQOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:14:19 -0400
Message-ID: <53C00D3C.7080808@zytor.com>
Date: Fri, 11 Jul 2014 09:13:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Moore <pmoore@redhat.com>
CC: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <aviro@redhat.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32
 filter
References: <cover.1405023592.git.rgb@redhat.com> <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com> <53BF62AA.20105@zytor.com> <1458762.ra4TnS54ZN@sifl>
In-Reply-To: <1458762.ra4TnS54ZN@sifl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 09:11 AM, Paul Moore wrote:
> On Thursday, July 10, 2014 09:06:02 PM H. Peter Anvin wrote:
>> Incidentally: do seccomp users know that on an x86-64 system you can
>> recevie system calls from any of the x86 architectures, regardless of
>> how the program is invoked?  (This is unusual, so normally denying those
>> "alien" calls is the right thing to do.)
> 
> I obviously can't speak for all seccomp users, but libseccomp handles this by 
> checking the seccomp_data->arch value at the start of the filter and killing 
> (by default) any non-native architectures.  If you want, you can change this 
> default behavior or add support for other architectures (e.g. create a filter 
> that allows both x86-64 and x32 but disallows x86, or any combination of the 
> three for that matter).
> 

OK, that seems reasonable.

	-hpa

